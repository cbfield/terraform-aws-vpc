variable "assign_generated_ipv6_cidr_block" {
  description = "Whether to request a /56 IPv6 CIDR block for the VPC"
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "Availability zones to distribute resources within"
  type        = list(string)
}

variable "bastion" {
  description = "Configurations for bastion hosts in this VPC"
  type = object({
    ami        = optional(string)
    public_key = optional(string)
    subnets    = list(string)
    ingress = optional(object({
      cidr_blocks     = optional(list(string))
      security_groups = optional(list(string))
    }))
  })
  default = {}
}

variable "cidr_block" {
  description = "A CIDR block to assign to the VPC"
  type        = string
}

variable "dhcp" {
  description = "Configurations for DHCP options for this VPC"
  type = object({
    domain_name          = optional(string)
    domain_name_servers  = optional(list(string))
    ntp_servers          = optional(list(string))
    netbios_name_servers = optional(list(string))
    netbios_node_type    = optional(number)
    tags                 = optional(map(string))
  })
  default = {
    domain_name          = null
    domain_name_servers  = null
    ntp_servers          = null
    netbios_name_servers = null
    netbios_node_type    = null
    tags                 = null
  }
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

variable "internet_gateway" {
  description = "Configurations for the internet gateway used by this VPC"
  type = object({
    tags = optional(map(string))
  })
  default = {
    tags = null
  }
}

variable "name" {
  description = "The name of the VPC, and the prefix for resources created within the VPC"
  type        = string
}

variable "subnet_groups" {
  description = "Configurations for groups of subnets. TODO better description"
  type = list(object({
    assign_ipv6_address_on_creation = optional(bool)
    customer_owned_ipv4_pool        = optional(string)
    first_netnum                    = number
    ipv6_first_netnum               = optional(number)
    ipv6_newbits                    = optional(number)
    ipv6_prefix                     = optional(string)
    map_customer_owned_ip_on_launch = optional(bool)
    map_public_ip_on_launch         = optional(bool)
    nacl = optional(object({
      ingress = optional(list(object({
        cidr_block  = string
        from_port   = number
        protocol    = string
        rule_action = string
        rule_number = number
        to_port     = number
      })))
      egress = optional(list(object({
        cidr_block  = string
        from_port   = number
        protocol    = string
        rule_action = string
        rule_number = number
        to_port     = number
      })))
      self_ingress = optional(bool)
      tags         = optional(map(string))
    }))
    name             = string
    newbits          = number
    outpost_arn      = optional(string)
    route_table_tags = optional(map(string))
    routes = optional(list(object({
      carrier_gateway_id          = optional(string)
      destination_cidr_block      = optional(string)
      destination_ipv6_cidr_block = optional(string)
      destination_prefix_list_id  = optional(string)
      egress_only_gateway_id      = optional(string)
      gateway_id                  = optional(string)
      instance_id                 = optional(string)
      local_gateway_id            = optional(string)
      nat_gateway_id              = optional(string)
      network_interface_id        = optional(string)
      transit_gateway_id          = optional(string)
      vpc_endpoint_id             = optional(string)
      vpc_peering_connection_id   = optional(string)
    })))
    tags = optional(map(string))
    type = string
  }))
  default = []
}

variable "tags" {
  description = "Tags to assign to the VPC"
  type        = map(string)
  default     = {}
}
