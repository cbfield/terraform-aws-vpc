```hcl
module "vpc_main" {
  source = "../../"

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
            from_port  = 443
            to_port    = 443
            protocol   = "tcp"
            action     = "allow"
            rule_no    = 2
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
            cidr_block = "0.0.0.0/0"
            from_port  = 1024
            to_port    = 65535
            protocol   = "tcp"
            action     = "allow"
            rule_no    = 1
          },
          {
            subnet_group = "front-end"
            from_port    = 8080
            to_port      = 8080
            protocol     = "tcp"
            action       = "allow"
            rule_no      = 10
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
          },
        ]
      }
    },
    {
      type         = "airgapped" # == no internet access; use "private" for things that require an internet connection
      name         = "persistence"
      newbits      = 8
      first_netnum = 5
      nacl = {
        ingress = [
          {
            subnet_group = "back-end"
            from_port    = 5432
            to_port      = 5432
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

```