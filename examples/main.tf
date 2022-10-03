module "create_devices" {
  source = "weaveworks-liquidmetal/liquidmetal/equinix"
  version = "0.0.1"

  project_name = "my-lm-project"
  public_key = "my ssh public key"
  org_id = "my org id"
  metal_auth_token = "my equinix auth token"
}

module "provision_hosts" {
  source = "weaveworks-liquidmetal/liquidmetal/equinix//modules/provision"
  version = "0.0.1"

  ts_auth_key = "my tailscale auth key"
  private_key_path = "/path/to/my/private/key"

  vlan_id = module.create_devices.vlan_id
  network_hub_address = module.create_devices.network_hub_ip
  microvm_host_addresses = module.create_devices.microvm_host_ips
  baremetal_host_addresses = module.create_devices.bare_metal_host_ips
}

# useful outputs to print
output "network_hub_ip" {
  value = module.create_devices.network_hub_ip
  description = "The address of the device created to act as a networking configuration hub"
}

output "microvm_host_ips" {
  value = module.create_devices.microvm_host_ips
  description = "The addresses of the devices provisioned as flintlock microvm hosts"
}

output "bare_metal_host_ips" {
  value = module.create_devices.bare_metal_host_ips
  description = "The addresses of the devices provisioned as baremetal hosts"
}
