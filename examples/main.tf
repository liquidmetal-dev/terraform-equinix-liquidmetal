module "create_devices" {
  source = "weaveworks-liquidmetal/terraform-liquidmetal-equinix"
  project_name = "my-lm-project"
  public_key = "my ssh public key"
  org_id = "my org id"
  metal_auth_token = "my equinix auth token"
}

module "provision_hosts" {
  source = "weaveworks-liquidmetal/terraform-liquidmetal-equinix"
  ts_auth_key = "my tailscale auth key"
  private_key_path = "/path/to/my/private/key"

  vlan_id = module.create_devices.vlan_id
  network_hub_address = module.create_devices.network_hub_ip
  microvm_host_addresses = module.create_devices.microvm_host_ips
  baremetal_host_addresses = module.create_devices.bare_metal_host_ips
}
