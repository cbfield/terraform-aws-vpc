module "public_vpc" {
  source = "../"

  name       = "main"
  cidr_block = "10.0.0.0/16"
  availability_zones = [
    "us-east-1a",
    "us-east-1b",
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
      routes = [
        {
          cidr_block         = "10.20.0.0/16"
          transit_gateway_id = "tgw-123123"
        }
      ]
    },
  ]

  transit_gateway_attachments = [
    { transit_gateway_id = "tgw-123123" },
  ]

  vpc_peering_connections = [
    {
      auto_accept   = true
      peer_owner_id = "111222333444"
      peer_vpc_id   = "vpc-123123"
      peer_region   = "us-east-1"
      tags          = { "something" = "whatever" }
    }
  ]
}
