# module "private_vpc" {
#   source = "../"

#   name       = "main"
#   cidr_block = "10.1.0.0/16"
#   availability_zones = [
#     "us-east-1a",
#     "us-east-1b",
#   ]

#   subnet_groups = [
#     {
#       type         = "private"
#       name         = "front-end"
#       newbits      = 8
#       first_netnum = 1
#       nacl = {
#         ingress = [{
#           cidr_block  = module.private_vpc.vpc.cidr_block
#           from_port   = 0
#           protocol    = "-1"
#           rule_action = "allow"
#           rule_number = 1
#           to_port     = 0
#         }]
#         egress = [{
#           cidr_block  = module.private_vpc.vpc.cidr_block
#           from_port   = 0
#           protocol    = "-1"
#           rule_action = "allow"
#           rule_number = 1
#           to_port     = 0
#         }]
#       }
#     },
#     {
#       type         = "private"
#       name         = "back-end"
#       newbits      = 8
#       first_netnum = 3
#       nacl = {
#         ingress = flatten([
#           for s in module.private_vpc.subnets["front-end"] : [
#             for port in local.backend_ports : {
#               cidr_block  = s.cidr_block
#               from_port   = port
#               protocol    = "-1"
#               rule_action = "allow"
#               rule_number = 1 + index(module.private_vpc.subnets["front-end"], s) + (10 * index(local.backend_ports, port))
#               to_port     = port
#         }]])
#         egress = [{
#           cidr_block  = "0.0.0.0/0"
#           from_port   = 0
#           protocol    = "-1"
#           rule_action = "allow"
#           rule_number = 1
#           to_port     = 0
#         }]
#       }
#     },
#     {
#       type         = "airgapped"
#       name         = "persistence"
#       newbits      = 8
#       first_netnum = 5
#       nacl = {
#         ingress = flatten([
#           for s in module.private_vpc.subnets["back-end"] : [
#             for port in local.persistence_ports : {
#               cidr_block  = s.cidr_block
#               from_port   = port
#               protocol    = "-1"
#               rule_action = "allow"
#               rule_number = 1 + index(module.private_vpc.subnets["back-end"], s) + (10 * index(local.persistence_ports, port))
#               to_port     = port
#         }]])
#       }
#     },
#   ]
# }
