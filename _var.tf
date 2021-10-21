variable "assign_generated_ipv6_cidr_block" {
  description = "Whether to request a /56 IPv6 CIDR block for the VPC"
  type        = bool
  default     = false
}

variable "cidr_block" {
  description = "A CIDR block to assign to the VPC"
  type        = string
}

variable "enable_classiclink" {
  description = "Whether or not to enable ClassicLink for the VPC"
  type        = bool
  default     = false
}

variable "enable_classiclink_dns_support" {
  description = "Whether or not to enable ClassicLink DNS support for the VPC"
  type        = bool
  default     = false
}

variable "enable_dns_hostnames" {
  description = "Whether or not to enable internal DNS hostnames within the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Whether or not to enable internal DNS support within the VPC"
  type        = bool
  default     = true
}

variable "instance_tenancy" {
  description = "default, dedicated, or host. Determines tenancy of instances launched within the VPC"
  type        = string
  default     = "default"
}

variable "name" {
  description = "The name of the VPC, and the prefix for resources created within the VPC"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the VPC"
  type        = map(string)
  default     = {}
}
