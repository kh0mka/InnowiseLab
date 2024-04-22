terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.public_subnet,
        aws.private_subnet
      ]
    }
  }
}

data "aws_ami" "latestUbuntu_public" {
  most_recent = true
  provider    = aws.public_subnet

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

data "aws_ami" "latestUbuntu_private" {
  most_recent = true
  provider    = aws.private_subnet

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "public_instance" {
  provider = aws.public_subnet

  ami           = data.aws_ami.latestUbuntu_public.id
  instance_type = var.instance_type

  security_groups = [var.public_instance_security_groups]
  subnet_id       = var.public_instance_subnet_id
  key_name        = var.public_instance_key_name

  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_public_instance", {}))
}

resource "aws_instance" "private_instance" {
  provider = aws.private_subnet

  ami           = data.aws_ami.latestUbuntu_private.id
  instance_type = var.instance_type

  security_groups = [var.private_instance_security_groups]
  subnet_id       = var.private_instance_subnet_id

  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_private_instance", {}))
}
