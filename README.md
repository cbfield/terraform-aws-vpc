# terraform-aws-vpc
A Terraform module for an AWS Virtual Private Cloud (VPC), with included subnets, route tables, NACLs, and internet/ nat gateways

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>3.6 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~>4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~>3.6 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~>4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_eip.ngw_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_key_pair.bastion_ec2_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_nat_gateway.ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.endpoint_nacl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.nacl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.ngw_nacl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.tgw_nacl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.ngw_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ngw_ephemeral_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ngw_subnet_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_route.igw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.ngw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.tgw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_resolver_rule_association.rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_route_table.endpoint_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.ngw_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.tgw_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.bastion_cidr_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.bastion_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.bastion_self_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.bastion_sg_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.endpoint_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.endpoint_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_subnet.endpoint_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.ngw_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.tgw_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options.dhcp_options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.dhcp_options_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_vpc_endpoint.endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_ipv4_cidr_block_association.secondary_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association) | resource |
| [aws_vpc_peering_connection.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.peer_accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [tls_private_key.bastion_ssh_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.al2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_generated_ipv6_cidr_block"></a> [assign\_generated\_ipv6\_cidr\_block](#input\_assign\_generated\_ipv6\_cidr\_block) | Whether to request a /56 IPv6 CIDR block for the VPC | `bool` | `false` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability zones to distribute resources within | `list(string)` | n/a | yes |
| <a name="input_bastion"></a> [bastion](#input\_bastion) | Configurations for bastion hosts in this VPC | <pre>object({<br>    ami        = optional(string)<br>    public_key = optional(string)<br>    subnets = list(object({<br>      subnet_group = string<br>      azs          = optional(list(string))<br>    }))<br>    ingress = optional(object({<br>      cidr_blocks     = optional(list(string))<br>      security_groups = optional(list(string))<br>    }))<br>  })</pre> | <pre>{<br>  "subnets": []<br>}</pre> | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | A CIDR block to assign to the VPC | `string` | n/a | yes |
| <a name="input_dhcp"></a> [dhcp](#input\_dhcp) | Configurations for DHCP options for this VPC | <pre>object({<br>    domain_name          = optional(string)<br>    domain_name_servers  = optional(list(string))<br>    ntp_servers          = optional(list(string))<br>    netbios_name_servers = optional(list(string))<br>    netbios_node_type    = optional(number)<br>    tags                 = optional(map(string))<br>  })</pre> | <pre>{<br>  "domain_name": null,<br>  "domain_name_servers": null,<br>  "netbios_name_servers": null,<br>  "netbios_node_type": null,<br>  "ntp_servers": null,<br>  "tags": null<br>}</pre> | no |
| <a name="input_enable_classiclink"></a> [enable\_classiclink](#input\_enable\_classiclink) | Whether or not to enable ClassicLink for the VPC | `bool` | `false` | no |
| <a name="input_enable_classiclink_dns_support"></a> [enable\_classiclink\_dns\_support](#input\_enable\_classiclink\_dns\_support) | Whether or not to enable ClassicLink DNS support for the VPC | `bool` | `false` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Whether or not to enable internal DNS hostnames within the VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Whether or not to enable internal DNS support within the VPC | `bool` | `true` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | default, dedicated, or host. Determines tenancy of instances launched within the VPC | `string` | `"default"` | no |
| <a name="input_internet_gateway"></a> [internet\_gateway](#input\_internet\_gateway) | Configurations for the internet gateway used by this VPC | <pre>object({<br>    tags = optional(map(string))<br>  })</pre> | <pre>{<br>  "tags": null<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the VPC, and the prefix for resources created within the VPC | `string` | n/a | yes |
| <a name="input_nat_gateway_subnets"></a> [nat\_gateway\_subnets](#input\_nat\_gateway\_subnets) | Configuration options for the subnets created to house Nat Gateway attachment network interfaces | <pre>object({<br>    newbits      = optional(number)<br>    first_netnum = optional(number)<br>  })</pre> | <pre>{<br>  "first_netnum": null,<br>  "newbits": null<br>}</pre> | no |
| <a name="input_route53_resolver_rule_associations"></a> [route53\_resolver\_rule\_associations](#input\_route53\_resolver\_rule\_associations) | Route 53 Resolver rules to associate with this VPC | `list(string)` | `[]` | no |
| <a name="input_secondary_ipv4_cidr_blocks"></a> [secondary\_ipv4\_cidr\_blocks](#input\_secondary\_ipv4\_cidr\_blocks) | Additional IPv4 CIDR blocks to assign to the VPC | <pre>list(object({<br>    cidr_block          = optional(string)<br>    ipv4_ipam_pool_id   = optional(string)<br>    ipv4_netmask_length = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_subnet_groups"></a> [subnet\_groups](#input\_subnet\_groups) | Configurations for groups of subnets. TODO better description | <pre>list(object({<br>    assign_ipv6_address_on_creation = optional(bool)<br>    customer_owned_ipv4_pool        = optional(string)<br>    first_netnum                    = number<br>    ipv6_first_netnum               = optional(number)<br>    ipv6_newbits                    = optional(number)<br>    ipv6_prefix                     = optional(string)<br>    map_customer_owned_ip_on_launch = optional(bool)<br>    map_public_ip_on_launch         = optional(bool)<br>    nacl = optional(object({<br>      ingress = optional(list(object({<br>        cidr_block      = optional(string)<br>        from_port       = number<br>        ipv6_cidr_block = optional(string)<br>        protocol        = string<br>        action          = string<br>        rule_no         = number<br>        subnet_group    = optional(string)<br>        to_port         = number<br>      })))<br>      egress = optional(list(object({<br>        cidr_block      = optional(string)<br>        from_port       = number<br>        ipv6_cidr_block = optional(string)<br>        protocol        = string<br>        action          = string<br>        rule_no         = number<br>        subnet_group    = optional(string)<br>        to_port         = number<br>      })))<br>      tags = optional(map(string))<br>    }))<br>    name             = string<br>    newbits          = number<br>    outpost_arn      = optional(string)<br>    route_table_tags = optional(map(string))<br>    routes = optional(list(object({<br>      carrier_gateway_id        = optional(string)<br>      cidr_block                = optional(string)<br>      ipv6_cidr_block           = optional(string)<br>      prefix_list_id            = optional(string)<br>      egress_only_gateway_id    = optional(string)<br>      gateway_id                = optional(string)<br>      instance_id               = optional(string)<br>      local_gateway_id          = optional(string)<br>      nat_gateway_id            = optional(string)<br>      network_interface_id      = optional(string)<br>      transit_gateway_id        = optional(string)<br>      vpc_endpoint_id           = optional(string)<br>      vpc_peering_connection_id = optional(string)<br>    })))<br>    tags = optional(map(string))<br>    type = string<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to the VPC | `map(string)` | `{}` | no |
| <a name="input_transit_gateway_attachments"></a> [transit\_gateway\_attachments](#input\_transit\_gateway\_attachments) | Attachments to transit gateways from this VPC | <pre>list(object({<br>    appliance_mode_support                          = optional(string)<br>    dns_support                                     = optional(string)<br>    ipv6_support                                    = optional(string)<br>    tags                                            = optional(map(string))<br>    transit_gateway_id                              = string<br>    transit_gateway_default_route_table_association = optional(bool)<br>    transit_gateway_default_route_table_propagation = optional(bool)<br>  }))</pre> | `[]` | no |
| <a name="input_transit_gateway_subnets"></a> [transit\_gateway\_subnets](#input\_transit\_gateway\_subnets) | Configuration options for the subnets created to house Transit Gateway attachment network interfaces | <pre>object({<br>    newbits      = optional(number)<br>    first_netnum = optional(number)<br>  })</pre> | <pre>{<br>  "first_netnum": null,<br>  "newbits": null<br>}</pre> | no |
| <a name="input_vpc_endpoint_subnets"></a> [vpc\_endpoint\_subnets](#input\_vpc\_endpoint\_subnets) | Configuration options for the subnets created to house VPC endpoints | <pre>object({<br>    newbits      = optional(number)<br>    first_netnum = optional(number)<br>  })</pre> | <pre>{<br>  "first_netnum": null,<br>  "newbits": null<br>}</pre> | no |
| <a name="input_vpc_endpoints"></a> [vpc\_endpoints](#input\_vpc\_endpoints) | VPC endpoints to create within this VPC | <pre>list(object({<br>    auto_accept         = optional(bool)<br>    policy              = optional(string)<br>    private_dns_enabled = optional(bool)<br>    route_tables = optional(list(object({<br>      subnet_group = string<br>      azs          = optional(list(string))<br>    })))<br>    service_name      = string<br>    tags              = optional(map(string))<br>    vpc_endpoint_type = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_peering_connection_accepters"></a> [vpc\_peering\_connection\_accepters](#input\_vpc\_peering\_connection\_accepters) | Accepters for vpc peering connections that originate elsewhere | <pre>list(object({<br>    auto_accept               = optional(bool)<br>    tags                      = optional(map(string))<br>    vpc_peering_connection_id = string<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_peering_connections"></a> [vpc\_peering\_connections](#input\_vpc\_peering\_connections) | Peering connections to make to VPCs elsewhere from this VPC | <pre>list(object({<br>    accepter = optional(object({<br>      allow_classic_link_to_remote_vpc = optional(bool)<br>      allow_remote_vpc_dns_resolution  = optional(bool)<br>      allow_vpc_to_remote_classic_link = optional(bool)<br>    }))<br>    auto_accept   = optional(bool)<br>    peer_owner_id = optional(string)<br>    peer_region   = optional(string)<br>    peer_vpc_id   = string<br>    requester = optional(object({<br>      allow_classic_link_to_remote_vpc = optional(bool)<br>      allow_remote_vpc_dns_resolution  = optional(bool)<br>      allow_vpc_to_remote_classic_link = optional(bool)<br>    }))<br>    tags = optional(map(string))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_assign_generated_ipv6_cidr_block"></a> [assign\_generated\_ipv6\_cidr\_block](#output\_assign\_generated\_ipv6\_cidr\_block) | The value provided for var.assign\_generated\_ipv6\_cidr\_block |
| <a name="output_aws_caller_id"></a> [aws\_caller\_id](#output\_aws\_caller\_id) | The AWS caller identity used to build the module |
| <a name="output_bastion"></a> [bastion](#output\_bastion) | The value provided for var.bastion |
| <a name="output_bastion_ec2_key"></a> [bastion\_ec2\_key](#output\_bastion\_ec2\_key) | The EC2 keypair created to provide access to the bastion hosts in this VPC |
| <a name="output_bastion_instances"></a> [bastion\_instances](#output\_bastion\_instances) | The ec2 instaces created as bastion hosts in this VPC |
| <a name="output_bastion_security_group"></a> [bastion\_security\_group](#output\_bastion\_security\_group) | The security group created for the bastion hosts in this VPC |
| <a name="output_bastion_ssh_key"></a> [bastion\_ssh\_key](#output\_bastion\_ssh\_key) | The tls key created to provide access to the bastions, if one was not provided |
| <a name="output_cidr_block"></a> [cidr\_block](#output\_cidr\_block) | The value provided for var.cidr\_block |
| <a name="output_dhcp"></a> [dhcp](#output\_dhcp) | The value provided for var.dhcp |
| <a name="output_dhcp_options"></a> [dhcp\_options](#output\_dhcp\_options) | The DHCP options configured for the VPC |
| <a name="output_enable_classiclink"></a> [enable\_classiclink](#output\_enable\_classiclink) | The provided value for var.enable\_classiclink |
| <a name="output_enable_classiclink_dns_support"></a> [enable\_classiclink\_dns\_support](#output\_enable\_classiclink\_dns\_support) | The provided value for var.enable\_classiclink\_dns\_support |
| <a name="output_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#output\_enable\_dns\_hostnames) | The provided value for var.enable\_dns\_hostnames |
| <a name="output_enable_dns_support"></a> [enable\_dns\_support](#output\_enable\_dns\_support) | The provided value for var.enable\_dns\_support |
| <a name="output_instance_tenancy"></a> [instance\_tenancy](#output\_instance\_tenancy) | The provided value for var.instance\_tenancy |
| <a name="output_internet_gateway"></a> [internet\_gateway](#output\_internet\_gateway) | The internet gateway created for this VPC |
| <a name="output_nacls"></a> [nacls](#output\_nacls) | NACLs created for subnet groups in this VPC |
| <a name="output_name"></a> [name](#output\_name) | The value provided for var.name |
| <a name="output_nat_gateway"></a> [nat\_gateway](#output\_nat\_gateway) | The nat gateways used by this VPC |
| <a name="output_nat_gateway_eip"></a> [nat\_gateway\_eip](#output\_nat\_gateway\_eip) | The elastic IP addresses used by the nat gateways in this VPC |
| <a name="output_nat_gateway_nacl"></a> [nat\_gateway\_nacl](#output\_nat\_gateway\_nacl) | The NACL that manages ingress and egress to the nat gateways for this VPC |
| <a name="output_nat_gateway_route_table"></a> [nat\_gateway\_route\_table](#output\_nat\_gateway\_route\_table) | The route table used by the nat gateways in this VPC |
| <a name="output_nat_gateway_subnets"></a> [nat\_gateway\_subnets](#output\_nat\_gateway\_subnets) | The subnets containing the nat gateways in this VPC |
| <a name="output_region"></a> [region](#output\_region) | The region containing the vpc |
| <a name="output_route53_resolver_rule_associations"></a> [route53\_resolver\_rule\_associations](#output\_route53\_resolver\_rule\_associations) | The value provided for var.route53\_resolver\_rule\_associations |
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables) | Route tables created for subnet groups in this VPC |
| <a name="output_secondary_ipv4_cidr_blocks"></a> [secondary\_ipv4\_cidr\_blocks](#output\_secondary\_ipv4\_cidr\_blocks) | The value provided for var.secondary\_ipv4\_cidr\_blocks |
| <a name="output_subnet_groups"></a> [subnet\_groups](#output\_subnet\_groups) | The provided value for var.subnet\_groups |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | The subnets created for subnet groups in this VPC |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags assigned to the VPC |
| <a name="output_transit_gateway_attachments"></a> [transit\_gateway\_attachments](#output\_transit\_gateway\_attachments) | Attachments to transit gateways from this VPC |
| <a name="output_transit_gateway_nacl"></a> [transit\_gateway\_nacl](#output\_transit\_gateway\_nacl) | The NACL used by the transit gateway subnets |
| <a name="output_transit_gateway_route_table"></a> [transit\_gateway\_route\_table](#output\_transit\_gateway\_route\_table) | The route table for the transit gateway subnets |
| <a name="output_transit_gateway_subnets"></a> [transit\_gateway\_subnets](#output\_transit\_gateway\_subnets) | The subnets created for Transit Gateway attachment network interfaces |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | The VPC resource object |
| <a name="output_vpc_endpoint_nacl"></a> [vpc\_endpoint\_nacl](#output\_vpc\_endpoint\_nacl) | The NACL used by the VPC endpoint subnets |
| <a name="output_vpc_endpoint_route_table"></a> [vpc\_endpoint\_route\_table](#output\_vpc\_endpoint\_route\_table) | The route table used by the VPC endpoint subnets |
| <a name="output_vpc_endpoint_security_group"></a> [vpc\_endpoint\_security\_group](#output\_vpc\_endpoint\_security\_group) | The security group used by the VPC endpoints in this VPC |
| <a name="output_vpc_endpoint_subnets"></a> [vpc\_endpoint\_subnets](#output\_vpc\_endpoint\_subnets) | The subnets that house VPC endpoints in this VPC |
| <a name="output_vpc_endpoints"></a> [vpc\_endpoints](#output\_vpc\_endpoints) | VPC endpoints created within this VPC |
| <a name="output_vpc_peering_connection_accepters"></a> [vpc\_peering\_connection\_accepters](#output\_vpc\_peering\_connection\_accepters) | VPC peering connections accepted by this VPC |
| <a name="output_vpc_peering_connections"></a> [vpc\_peering\_connections](#output\_vpc\_peering\_connections) | VPC peering connections originating from this VPC |
<!-- END_TF_DOCS -->
