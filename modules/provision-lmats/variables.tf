variable "microvm_host_device_count" {
  description = "The number of devices to provision as flintlock hosts."
  type        = number
  default     = 2
  validation {
    condition     = var.microvm_host_device_count <= 3
    error_message = "Too many hosts requested."
  }
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
