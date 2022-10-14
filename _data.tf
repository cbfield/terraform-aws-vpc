data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ami" "al2" {
  count = try(var.bastion.ami == null, true) ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}
