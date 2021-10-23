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

output "nacls" {
  description = "NACLs created for subnet groups in this VPC"
  value       = aws_network_acl.nacl
}

output "name" {
  description = "The value provided for var.name"
  value       = var.name
}

output "ngw" {
  description = "The nat gateways used by this VPC"
  value       = aws_nat_gateway.ngw
}

output "ngw_eip" {
  description = "The elastic IP addresses used by the nat gateways in this VPC"
  value       = aws_eip.ngw_eip
}

output "ngw_nacl" {
  description = "The NACL that manages ingress and egress to the nat gateways for this VPC"
  value       = aws_network_acl.ngw_nacl
}

output "ngw_nacl_egress" {
  description = "Egress rules for the nat gateway NACL"
  value       = aws_network_acl_rule.ngw_egress
}

output "ngw_nacl_ingress" {
  description = "Ingress rules for the nat gateway NACL"
  value       = aws_network_acl_rule.ngw_ingress
}

output "ngw_routes" {
  description = "Routes in the nat gateway route table"
  value       = aws_route.ngw_route
}

output "ngw_route_table" {
  description = "The route table used by the nat gateways in this VPC"
  value       = aws_route_table.ngw_route_table
}

output "ngw_subnets" {
  description = "The subnets containing the nat gateways in this VPC"
  value       = aws_subnet.ngw_subnet
}

output "route_tables" {
  description = "Route tables created for subnet groups in this VPC"
  value       = aws_route_table.route_table
}

output "routes" {
  description = "Routes assigned to the route tables in this VPC"
  value       = aws_route.route
}

output "subnet_groups" {
  description = "The provided value for var.subnet_groups"
  value       = var.subnet_groups
}

output "subnets" {
  description = "The subnets created for subnet groups in this VPC"
  value       = aws_subnet.subnet
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
