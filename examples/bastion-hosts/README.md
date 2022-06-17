```hcl
module "vpc_main" {
  source = "../../"

  name       = "main"
  cidr_block = "10.0.0.0/16"
  availability_zones = [
    "us-west-2a",
    "us-west-2b",
  ]

  bastion = {
    subnets = [
      {
        subnet_group = "front-end"
        azs          = ["us-west-2a"] # omit `azs` to make a bastion in each AZ defined by var.availability_zones
      },
      {
        subnet_group = "back-end"
        azs          = ["us-west-2a"]
      },
    ]
    ingress = {
      cidr_blocks     = ["10.0.0.0/8"]
      security_groups = ["sg-123123"]
    }
    # ami = "ami-123123" (optional)
    # public_key = "ssh-rsa ..." (optional)
  }

  subnet_groups = [
    {
      type         = "public"
      name         = "front-end"
      newbits      = 8
      first_netnum = 1
    },
    {
      type         = "private"
      name         = "back-end"
      newbits      = 8
      first_netnum = 3
    }
  ]
}
```
