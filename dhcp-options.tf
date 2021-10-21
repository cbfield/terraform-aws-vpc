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

resource "aws_vpc_dhcp_options_association" "dhcp_options_association" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options.id
}
