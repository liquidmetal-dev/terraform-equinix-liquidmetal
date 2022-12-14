# used by the provision modules
output "network_hub_ip" {
  value = equinix_metal_device.network_hub.network.0.address
  description = "The address of the device created to act as a networking configuration hub"
}

# used by the provision modules
output "microvm_host_ips" {
  value = equinix_metal_device.microvm_host.*.network.0.address
  description = "The addresses of the devices provisioned as flintlock microvm hosts"
}

# used by the provision modules
output "bare_metal_host_ips" {
  value = equinix_metal_device.baremetal_host.*.network.0.address
  description = "The addresses of the devices provisioned as baremetal hosts"
}

# used by the provision modules
output "vlan_id" {
  value = equinix_metal_vlan.vlan.vxlan
  description = "The ID of the created VLAN."
}

output "terraform_state_location" {
  value = <<EOV
${path.cwd}/terraform.tfstate.d/${terraform.workspace}/terraform.tfstate
EOV
}
