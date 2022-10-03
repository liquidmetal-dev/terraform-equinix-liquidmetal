output "network_hub_ip" {
  value = var.network_hub_address
  description = "The address of the device created to act as a networking configuration hub"
}

output "microvm_host_ips" {
  value = var.microvm_host_addresses
  description = "The addresses of the devices provisioned as flintlock microvm hosts"
}

output "bare_metal_host_ips" {
  value = var.baremetal_host_addresses
  description = "The addresses of the devices provisioned as baremetal hosts"
}

