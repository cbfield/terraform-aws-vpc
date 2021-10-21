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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
    "Managed By Terraform" = "true"
  })
}
