data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ami" "al2" {
  count = (
    var.bastion != null ? (
      var.bastion.ami == null ? 1 : 0
    ) : 0
  )

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}
