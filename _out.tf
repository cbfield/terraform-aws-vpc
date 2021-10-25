output "assign_generated_ipv6_cidr_block" {
  description = "The value provided for var.assign_generated_ipv6_cidr_block"
  value       = var.assign_generated_ipv6_cidr_block
}

output "bastion" {
  description = "The value provided for var.bastion"
  value       = var.bastion
}

output "bastion_instances" {
  description = "The ec2 instaces created as bastion hosts in this VPC"
  value       = aws_instance.bastion
}

output "bastion_ec2_key" {
  description = "The EC2 keypair created to provide access to the bastion hosts in this VPC"
  value       = aws_key_pair.bastion_ec2_key
}

output "bastion_security_group" {
  description = "The security group created for the bastion hosts in this VPC"
  value       = aws_security_group.bastion
}

output "bastion_ssh_key" {
  description = "The tls key created to provide access to the bastions, if one was not provided"
  value       = try(var.bastion.public_key, null)
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
  value = {
    for group in var.subnet_groups : group.name => aws_network_acl.nacl[group.name]
  }
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
  value = merge({
    for group in [for g in var.subnet_groups : g if g.type != "private"] : group.name => (
      aws_route_table.route_table[group.name]
    )
    }, {
    for group in [for g in var.subnet_groups : g if g.type == "private"] : group.name => {
      for az in var.availability_zones : az => aws_route_table.route_table["${group.name}-${az}"]
    }
  })
}

output "subnet_groups" {
  description = "The provided value for var.subnet_groups"
  value       = var.subnet_groups
}

output "subnets" {
  description = "The subnets created for subnet groups in this VPC"
  value = {
    for group in var.subnet_groups : group.name => {
      for az in var.availability_zones : az => aws_subnet.subnet["${group.name}-${az}"]
    }
  }
}

output "tags" {
  description = "Tags assigned to the VPC"
  value = merge(var.tags, {
    "Managed By Terraform" = "true"
  })
}

output "tgw_attachments" {
  description = "Attachments to transit gateways from this VPC"
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment
}

output "tgw_nacl" {
  description = "The NACL used by the transit gateway subnets"
  value       = aws_network_acl.tgw_nacl
}

output "tgw_route_table" {
  description = "The route table for the transit gateway subnets"
  value       = aws_route_table.tgw_route_table
}

output "tgw_subnets" {
  description = "The subnets created for transit gateway attachment network interfaces"
  value       = aws_subnet.tgw_subnet
}

output "transit_gateway_attachments" {
  description = "The value provided for var.transit_gateway_attachments"
  value       = var.transit_gateway_attachments
}

output "vpc" {
  description = "The VPC resource object"
  value       = aws_vpc.vpc
}

output "vpc_endpoint_nacl" {
  description = "The NACL used by the VPC endpoint subnets"
  value       = aws_network_acl.endpoint_nacl
}

output "vpc_endpoint_route_table" {
  description = "The route table used by the VPC endpoint subnets"
  value       = aws_route_table.endpoint_route_table
}

output "vpc_endpoint_security_group" {
  description = "The security group used by the VPC endpoints in this VPC"
  value       = aws_security_group.endpoint
}

output "vpc_endpoint_subnets" {
  description = "The subnets that house VPC endpoints in this VPC"
  value       = aws_subnet.endpoint_subnet
}

output "vpc_endpoints" {
  description = "VPC endpoints created within this VPC"
  value       = aws_vpc_endpoint.endpoint
}
