variable "microvm_host_device_count" {
  description = "number of flintlock hosts to create"
  type        = number
  default     = 2
  validation {
    condition     = var.microvm_host_device_count <= 3
    error_message = "Too many hosts requested."
  }
}

variable "bare_metal_device_count" {
  description = "number of baremetal hosts to create"
  type        = number
  default     = 0
  validation {
    condition     = var.bare_metal_device_count <= 3
    error_message = "Too many hosts requested."
  }
}

variable "ts_auth_key" {
  description = "Auth key for tailscale vpn"
  type        = string
  sensitive   = true
}

variable "private_key_path" {
  description = "the path to the private key to use for SSH"
  type        = string
}

variable "flintlock_version" {
  description = "the version of flintlock to provision hosts with (default: latest)"
  type        = string
  default     = "latest"
}

variable "firecracker_version" {
  description = "the version of firecracker to provision hosts with (default: latest)"
  type        = string
  default     = "latest"
}

variable "network_hub_address" {
  description = "the ip address of the network device in equinix"
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
