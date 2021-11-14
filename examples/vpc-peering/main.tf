module "vpc_main" {
  source = "../../"

  name       = "main"
  cidr_block = "10.0.0.0/16"
  availability_zones = [
    "us-west-2a",
    "us-west-2b",
  ]

  vpc_peering_connections = [
    {
      peer_vpc_id   = "vpc-123123"
      peer_region   = "us-east-1"    # only required if it's in another region
      peer_owner_id = "111222333444" # only required if it's owned by another AWS account
      # ... optional attributes
    }
  ]

  vpc_peering_connection_accepters = [
    {
      vpc_peering_connection_id = "pcx-123123"
      # ... optional attributes
    }
  ]

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
