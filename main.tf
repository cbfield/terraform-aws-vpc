resource "aws_vpc" "vpc" {
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  cidr_block                       = var.cidr_block
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  instance_tenancy                 = var.instance_tenancy

  tags = merge(var.tags, {
    "Managed By Terraform" = "true"
  })
}

resource "aws_vpc_dhcp_options" "dhcp_options" {
  domain_name          = var.dhcp.domain_name
  domain_name_servers  = var.dhcp.domain_name_servers
  ntp_servers          = var.dhcp.ntp_servers
  netbios_name_servers = var.dhcp.netbios_name_servers
  netbios_node_type    = var.dhcp.netbios_node_type

  tags = merge(var.dhcp.tags, {
    "Managed By Terraform" = "true"
  })
}
