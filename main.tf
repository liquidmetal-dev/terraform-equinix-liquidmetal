terraform {
  required_providers {
    metal = {
      version = "~> 3.2.2"
      source  = "equinix/metal"
    }
  }
}

provider "metal" {
  auth_token = var.metal_auth_token
}

# Create new project
resource "metal_project" "liquid_metal_demo" {
  name            = var.project_name
  organization_id = var.org_id
}

# Add SSH key
resource "metal_project_ssh_key" "demo_key" {
  name       = "liquid-metal-demo-key"
  public_key = var.public_key
  project_id = metal_project.liquid_metal_demo.id
}

# Create VLAN in project
resource "metal_vlan" "vlan" {
  description = "VLAN for liquid-metal-demo"
  metro       = var.metro
  project_id  = metal_project.liquid_metal_demo.id
}

# Create network hub device for dhcp, nat routing, vpn etc
resource "metal_device" "network_hub" {
  hostname            = "network-hub"
  plan                = var.server_type
  metro               = var.metro
  # this device uses an older version of ubuntu until we figure out the networking changes with 22
  operating_system    = "ubuntu_20_04"
  billing_cycle       = "hourly"
  user_data           = "#!/bin/bash\ncurl -s https://raw.githubusercontent.com/masters-of-cats/a-new-hope/main/install.sh | bash -s"
  project_ssh_key_ids = [metal_project_ssh_key.demo_key.id]
  project_id          = metal_project.liquid_metal_demo.id
}

# Update the network hub device networking to be Hybrid-Bonded with VLAN attached
resource "metal_port" "bond0_network_hub" {
  port_id  = [for p in metal_device.network_hub.ports : p.id if p.name == "bond0"][0]
  layer2   = false
  bonded   = true
  vlan_ids = [metal_vlan.vlan.id]
}

# Create N devices to act as flintlock hosts
resource "metal_device" "microvm_host" {
  count               = var.microvm_host_device_count
  hostname            = "host-${count.index}"
  plan                = var.server_type
  metro               = var.metro
  operating_system    = var.operating_system
  billing_cycle       = "hourly"
  user_data           = "#!/bin/bash\ncurl -s https://raw.githubusercontent.com/masters-of-cats/a-new-hope/main/install.sh | bash -s"
  project_ssh_key_ids = [metal_project_ssh_key.demo_key.id]
  project_id          = metal_project.liquid_metal_demo.id
}

# Update the host devices' networking to be Hybrid-Bonded with VLAN attached
resource "metal_port" "bond0_host" {
  count    = var.microvm_host_device_count
  port_id  = [for p in metal_device.microvm_host[count.index].ports : p.id if p.name == "bond0"][0]
  layer2   = false
  bonded   = true
  vlan_ids = [metal_vlan.vlan.id]
}

# Create N devices to act as baremetal hosts
resource "metal_device" "baremetal_host" {
  count               = var.bare_metal_device_count
  hostname            = "bm-${count.index}"
  plan                = var.server_type
  metro               = var.metro
  operating_system    = var.operating_system
  billing_cycle       = "hourly"
  user_data           = "#!/bin/bash\ncurl -s https://raw.githubusercontent.com/masters-of-cats/a-new-hope/main/install.sh | bash -s"
  project_ssh_key_ids = [metal_project_ssh_key.demo_key.id]
  project_id          = metal_project.liquid_metal_demo.id
}

# Update the host devices' networking to be Hybrid-Bonded with VLAN attached
resource "metal_port" "bond0_bmhost" {
  count    = var.bare_metal_device_count
  port_id  = [for p in metal_device.baremetal_host[count.index].ports : p.id if p.name == "bond0"][0]
  layer2   = false
  bonded   = true
  vlan_ids = [metal_vlan.vlan.id]
}
