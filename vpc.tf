resource "aws_vpc" "vpc" {
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  cidr_block                       = var.cidr_block
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  instance_tenancy                 = var.instance_tenancy

  tags = merge(var.tags, {
    "Availability Zones"   = join(",", var.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = var.name
  })
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  for_each = {
    for cidr in var.secondary_ipv4_cidr_blocks : coalesce(
      cidr.cidr_block,
      "${coalesce(cidr.ipv4_ipam_pool_id, "null")}-${coalesce(cidr.ipv4_netmask_length, "null")}"
    ) => cidr
  }

  cidr_block          = each.value.cidr_block
  ipv4_ipam_pool_id   = each.value.ipv4_ipam_pool_id
  ipv4_netmask_length = each.value.ipv4_netmask_length
  vpc_id              = aws_vpc.vpc.id
}
