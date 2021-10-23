resource "aws_vpc" "vpc" {
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  cidr_block                       = var.cidr_block
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  instance_tenancy                 = var.instance_tenancy

  tags = merge(var.tags, {
    "Availability Zones"   = join(",", local.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = var.name
  })
}
