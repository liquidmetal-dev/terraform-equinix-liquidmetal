variable "project_name" {
  description = "Project name"
  type        = string
  default     = "liquid-metal-demo"
}

variable "org_id" {
  description = "Org id"
  type        = string
}

variable "metro" {
  description = "Metro to create resources in"
  type        = string
  default     = "am"
}

variable "server_type" {
  description = "The type/plan to use for devices"
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
  description = "The operating system to use for devices"
  type        = string
  default     = "ubuntu_22_04"
}

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

variable "metal_auth_token" {
  description = "Auth token"
  type        = string
  sensitive   = true
}

variable "public_key" {
  description = "public key to add to hosts"
  type        = string
  sensitive   = true
}
