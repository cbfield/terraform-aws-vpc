output "assign_generated_ipv6_cidr_block" {
  description = "The value provided for var.assign_generated_ipv6_cidr_block"
  value       = var.assign_generated_ipv6_cidr_block
}

output "aws_caller_id" {
  description = "The AWS caller identity used to build the module"
  value       = data.aws_caller_identity.current
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
  value       = one(tls_private_key.bastion_ssh_key)
  sensitive   = true
}

output "cidr_block" {
  description = "The value provided for var.cidr_block"
  value       = var.cidr_block
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
  description = "Network ACLs created for subnet groups in this VPC"
  value       = aws_network_acl.nacl
}

output "nacls_by_group" {
  description = "Network ACLs created for subnet groups in this VPC, nested by group (ex. module.my_vpc.nacls_by_group[\"my-group\"].arn)"
  value = {
    for group in var.subnet_groups : group.name => aws_network_acl.nacl[group.name]
  }
}

output "name" {
  description = "The value provided for var.name"
  value       = var.name
}

output "nat_gateway" {
  description = "The nat gateways used by this VPC"
  value       = aws_nat_gateway.ngw
}

output "nat_gateway_eip" {
  description = "The elastic IP addresses used by the nat gateways in this VPC"
  value       = aws_eip.ngw_eip
}

output "nat_gateway_nacl" {
  description = "The NACL that manages ingress and egress to the nat gateways for this VPC"
  value       = aws_network_acl.ngw_nacl
}

output "nat_gateway_route_table" {
  description = "The route table used by the nat gateways in this VPC"
  value       = aws_route_table.ngw_route_table
}

output "nat_gateway_subnets" {
  description = "The subnets containing the nat gateways in this VPC"
  value       = aws_subnet.ngw_subnet
}

output "region" {
  description = "The region containing the vpc"
  value       = data.aws_region.current
}

output "route53_resolver_rule_associations" {
  description = "The value provided for var.route53_resolver_rule_associations"
  value       = var.route53_resolver_rule_associations
}

output "route_tables" {
  description = "Route tables created for this VPC"
  value       = aws_route_table.route_table
}

output "route_tables_by_group" {
  description = <<-EOF
    Route tables created for this VPC. Nested by group and AZ (ex. module.my_vpc.route_tables_by_group[\"my-group\"][\"us-west-1a\"].arn) for private subnet groups,
    and nested by group (ex. module.my_vpc.route_tables_by_group[\"my-group\"].arn) for public and airgapped subnet groups
  EOF
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

output "secondary_ipv4_cidr_blocks" {
  description = "The value provided for var.secondary_ipv4_cidr_blocks"
  value       = var.secondary_ipv4_cidr_blocks
}

output "subnet_groups" {
  description = "The provided value for var.subnet_groups"
  value       = var.subnet_groups
}

output "subnets" {
  description = "Subnets created in this VPC"
  value       = aws_subnet.subnet
}

output "subnets_by_group" {
  description = "Subnets created in this VPC, nested by group and AZ (ex. module.my_vpc.subnets_by_group[\"my-group\"][\"us-west-1a\"].arn)"
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

output "transit_gateway_attachments" {
  description = "Attachments to transit gateways from this VPC"
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment
}

output "transit_gateway_nacl" {
  description = "The NACL used by the transit gateway subnets"
  value       = aws_network_acl.tgw_nacl
}

output "transit_gateway_route_table" {
  description = "The route table for the transit gateway subnets"
  value       = aws_route_table.tgw_route_table
}

output "transit_gateway_subnets" {
  description = "The subnets created for Transit Gateway attachment network interfaces"
  value       = aws_subnet.tgw_subnet
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

output "vpc_peering_connection_accepters" {
  description = "VPC peering connections accepted by this VPC"
  value       = aws_vpc_peering_connection_accepter.peer_accepter
}

output "vpc_peering_connections" {
  description = "VPC peering connections originating from this VPC"
  value       = aws_vpc_peering_connection.peer
}
