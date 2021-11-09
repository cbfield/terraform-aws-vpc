module "vpc_main" {
  source = "../"

  name       = "main"
  cidr_block = "10.0.0.0/16"
  availability_zones = [
    "us-west-2a",
    "us-west-2b",
  ]

  subnet_groups = [
    {
      type         = "public"
      name         = "front-end"
      newbits      = 8
      first_netnum = 1
      nacl = {
        ingress = [
          {
            cidr_block = "0.0.0.0/0"
            from_port  = 1024
            to_port    = 65535
            protocol   = "tcp"
            action     = "allow"
            rule_no    = 1
          },
          {
            cidr_block = "0.0.0.0/0"
            from_port  = 80
            to_port    = 80
            protocol   = "tcp"
            action     = "allow"
            rule_no    = 2
          },
          {
            cidr_block = "0.0.0.0/0"
            from_port  = 443
            to_port    = 443
            protocol   = "tcp"
            action     = "allow"
            rule_no    = 3
          },
        ]
        egress = [
          {
            cidr_block = "0.0.0.0/0"
            from_port  = 0
            to_port    = 0
            protocol   = "-1"
            action     = "allow"
            rule_no    = 1
          }
        ]
      }
    },
    {
      type         = "private"
      name         = "back-end"
      newbits      = 8
      first_netnum = 3
      nacl = {
        ingress = [
          {
            subnet_group = "front-end"
            from_port    = 8080
            to_port      = 8080
            protocol     = "tcp"
            action       = "allow"
            rule_no      = 1
          }
        ]
        egress = [
          {
            cidr_block = "0.0.0.0/0"
            from_port  = 0
            to_port    = 0
            protocol   = "-1"
            action     = "allow"
            rule_no    = 1
          }
        ]
      }
    }
  ]
}
