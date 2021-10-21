output "assign_generated_ipv6_cidr_block" {
  description = "The value provided for var.assign_generated_ipv6_cidr_block"
  value       = var.assign_generated_ipv6_cidr_block
}

output "cidr_block" {
  description = "The value provided for var.cidr_block"
  value       = var.cidr_block
}

output "enable_classiclink" {
  description = "The provided value for var.enable_classiclink"
  value       = var.enable_classiclink
}

output "enable_classiclink_dns_support" {
  description = "The provided value for var.enable_classiclink_dns_support"
  value       = var.enable_classiclink_dns_support
}

output "enable_dns_hostnames" {
  description = "The provided value for var.enable_dns_hostnames"
  value       = var.enable_dns_hostnames
}

output "enable_dns_support" {
  description = "The provided value for var.enable_dns_support"
  value       = var.enable_dns_support
}

output "dhcp" {
  description = "The value provided for var.dhcp"
  value       = var.dhcp
}

output "dhcp_options" {
  description = "The DHCP options configured for the VPC"
  value       = aws_vpc_dhcp_options.dhcp_options
}

output "instance_tenancy" {
  description = "The provided value for var.instance_tenancy"
  value       = var.instance_tenancy
}

output "internet_gateway" {
  description = "The internet gateway created for this VPC"
  value       = aws_internet_gateway.igw
}

output "name" {
  description = "The value provided for var.name"
  value       = var.name
}

output "tags" {
  description = "Tags assigned to the VPC"
  value = merge(var.tags, {
    "Managed By Terraform" = "true"
  })
}

output "vpc" {
  description = "The VPC resource object"
  value       = aws_vpc.vpc
}
