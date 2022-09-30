output "project_name" {
  value = metal_project.liquid_metal_demo.name
}
output "network_hub_ip" {
  value = metal_device.network_hub.network.0.address
}
output "microvm_host_ips" {
  value = metal_device.microvm_host.*.network.0.address
}
output "bare_metal_host_ips" {
  value = metal_device.baremetal_host.*.network.0.address
}
output "vlan_id" {
  value = metal_vlan.vlan.vxlan
}

output "terraform_state_location" {
  value = <<EOV
${path.cwd}/terraform.tfstate.d/${terraform.workspace}/terraform.tfstate
EOV
}
