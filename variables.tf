variable "project_name" {
  description = "The name of the project to create in Equinix. Note that project names are not unique"
  type        = string
  default     = "liquid-metal-demo"
}

variable "org_id" {
  description = "The Org ID to create the project under."
  type        = string
}

variable "metro" {
  description = "The metro to create resources in."
  type        = string
  default     = "am"
}

variable "server_type" {
  description = "The type/plan to use for devices."
  type        = string
  default     = "c3.small.x86"
  validation {
    condition = contains([
      "c3.small.x86",
      "m3.small.x86",
      "c3.medium.x86",
      ],
    var.server_type)
    error_message = "Disallowed instance type."
  }
}

variable "operating_system" {
  description = "The operating system to use for devices."
  type        = string
  default     = "ubuntu_20_04"
}

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

variable "metal_auth_token" {
  description = "The auth token for Equinix"
  type        = string
  sensitive   = true
}

variable "public_key" {
  description = "An SSH public key."
  type        = string
}
