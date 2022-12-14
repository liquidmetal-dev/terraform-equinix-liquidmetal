terraform {
  required_providers {
    equinix = {
      version = "~> 1.11.1"
      source  = "equinix/equinix"
    }
  }
}

provider "equinix" {
  auth_token = var.metal_auth_token
}

# Create new project in Equinix.
# Note that Equinix project names are not unique.
resource "equinix_metal_project" "liquid_metal_demo" {
  name            = var.project_name
  organization_id = var.org_id
}

# Add an SSH key to the project
resource "equinix_metal_project_ssh_key" "demo_key" {
  name       = "liquid-metal-demo-key"
  public_key = var.public_key
  project_id = equinix_metal_project.liquid_metal_demo.id
}

# Create a VLAN in the project
resource "equinix_metal_vlan" "vlan" {
  description = "VLAN for liquid-metal-demo"
  metro       = var.metro
  project_id  = equinix_metal_project.liquid_metal_demo.id
}

# Create network hub device for dhcp, nat routing, vpn etc
# Technically this separate device does not need to exist, but we use it like this
# to keep things clear in our heads. Later refactoring may make this optional.
resource "equinix_metal_device" "network_hub" {
  hostname            = "network-hub"
  plan                = var.server_type
  metro               = var.metro
  # this device uses an older version of ubuntu until we figure out the networking changes with 22
  operating_system    = "ubuntu_20_04"
  billing_cycle       = "hourly"
  user_data           = "#!/bin/bash\ncurl -s https://raw.githubusercontent.com/masters-of-cats/a-new-hope/main/install.sh | bash -s"
  project_ssh_key_ids = [equinix_metal_project_ssh_key.demo_key.id]
  project_id          = equinix_metal_project.liquid_metal_demo.id
}

# Update the network hub device networking to be Hybrid-Bonded with VLAN attached
resource "equinix_metal_port" "bond0_network_hub" {
  port_id  = [for p in equinix_metal_device.network_hub.ports : p.id if p.name == "bond0"][0]
  layer2   = false
  bonded   = true
  vlan_ids = [equinix_metal_vlan.vlan.id]
}

# Create {microvm_host_device_count} devices to act as flintlock hosts
resource "equinix_metal_device" "microvm_host" {
  count               = var.microvm_host_device_count
  hostname            = "host-${count.index}"
  plan                = var.server_type
  metro               = var.metro
  operating_system    = var.operating_system
  billing_cycle       = "hourly"
  user_data           = "#!/bin/bash\ncurl -s https://raw.githubusercontent.com/masters-of-cats/a-new-hope/main/install.sh | bash -s"
  project_ssh_key_ids = [equinix_metal_project_ssh_key.demo_key.id]
  project_id          = equinix_metal_project.liquid_metal_demo.id
}

# Update the microvm host devices' networking to be Hybrid-Bonded with VLAN attached
resource "equinix_metal_port" "bond0_host" {
  count    = var.microvm_host_device_count
  port_id  = [for p in equinix_metal_device.microvm_host[count.index].ports : p.id if p.name == "bond0"][0]
  layer2   = false
  bonded   = true
  vlan_ids = [equinix_metal_vlan.vlan.id]
}

# Create {bare_metal_device_count} devices to act as baremetal hosts
# Baremetal hosts will not be provisioned to run flintlock, but are intended
# to be used as single kubernetes nodes.
# This is part of the POC mixed-mode work and will be refactored out of the main
# module at some point.
resource "equinix_metal_device" "baremetal_host" {
  count               = var.bare_metal_device_count
  hostname            = "bm-${count.index}"
  plan                = var.server_type
  metro               = var.metro
  operating_system    = var.operating_system
  billing_cycle       = "hourly"
  user_data           = "#!/bin/bash\ncurl -s https://raw.githubusercontent.com/masters-of-cats/a-new-hope/main/install.sh | bash -s"
  project_ssh_key_ids = [equinix_metal_project_ssh_key.demo_key.id]
  project_id          = equinix_metal_project.liquid_metal_demo.id
}

# Update the baremetal devices' networking to be Hybrid-Bonded with VLAN attached
resource "equinix_metal_port" "bond0_bmhost" {
  count    = var.bare_metal_device_count
  port_id  = [for p in equinix_metal_device.baremetal_host[count.index].ports : p.id if p.name == "bond0"][0]
  layer2   = false
  bonded   = true
  vlan_ids = [equinix_metal_vlan.vlan.id]
}
