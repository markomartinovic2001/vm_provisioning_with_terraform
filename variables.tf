variable "vm_name" {
  description = "Name of the VM to create"
  type        = string
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
}

variable "memory_mb" {
  description = "Memory in MB"
  type        = number
}

variable "vm_template_id" {
  description = "Template VM ID to clone from"
  type        = number
  default     = 104
}

variable "vm_id" {
  description = "VM ID for new VM"
  type        = number
}

variable "ip_range_start" {
  description = "Start of IP range"
  type        = number
  default     = 11
}

variable "ip_range_end" {
  description = "End of IP range"
  type        = number
  default     = 49
}

variable "network_prefix" {
  description = "Network prefix (e.g., 192.168.0)"
  type        = string
  default     = "192.168.0"
}
