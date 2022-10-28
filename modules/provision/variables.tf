variable "microvm_host_device_count" {
  description = "The number of devices to provision as flintlock hosts."
  type        = number
  default     = 2
}

variable "bare_metal_device_count" {
  description = "The number of devices to provision as bare metal hosts."
  type        = number
  default     = 0
}

variable "ts_auth_key" {
  description = "The personal/team auth key for Tailscale."
  type        = string
  sensitive   = true
}

variable "private_key_path" {
  description = "The path to the private key to use for SSH"
  type        = string
}

variable "flintlock_version" {
  description = "The version of flintlock to provision hosts with (default: latest)"
  type        = string
  default     = "latest"
}

variable "firecracker_version" {
  description = "The version of firecracker to provision hosts with (default: latest)"
  type        = string
  default     = "latest"
}

variable "network_hub_address" {
  description = "The ip address of the network hub device."
  type        = string
}

variable "vlan_id" {
  description = "ID of the VLAN created in equinix"
  type        = string
}

variable "microvm_host_addresses" {
  description = "IP addresses of the microvm hosts created in equinix"
  type        = list(string)
}

variable "baremetal_host_addresses" {
  description = "IP addresses of the baremetal hosts created in equinix"
  type        = list(string)
}
