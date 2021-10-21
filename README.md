# terraform-aws-vpc
A Terraform module for an AWS Virtual Private Cloud (VPC), with included subnets, route tables, NACLs, and internet/ nat gateways

# TODO
- some kind of subnet argument ("classes" of subnets? [public, private, persistence]) (route table(s) and NACL(s))
- VPC endpoints argument
- bastions argument w/ ami attribute
- dhcp options
- transit gateway attachments (maybe just as a route argument in the subnets)
