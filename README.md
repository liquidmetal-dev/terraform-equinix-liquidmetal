# Liquid Metal on Equinix

These terraform modules can be used to create and provision a Liquid Metal
Platform on Equinix.

They are still being refactored, and represent a first step in simplifying
the amount of similar terraform modules that we have lying around.

## Usage

There are 3 modules:
- `create` will set up some infrastructure in Equinix:
	- A new project
	- A device to act as a networking hub
	- `N` microvm host devices
	- `N` baremetal host devices
	- A VLAN
- `provision` will bootstrap the devices to run Liquid Metal
- `provision-test` will bootstrap the devices with no network access. This is
	used for running e2e test suites.

### Requirments

- Equinix account
- Tailscale account

### Example

```terraform
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
```
