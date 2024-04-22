data "aws_ami" "latest_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "instance" {
  count = var.instance_count

  ami             = data.aws_ami.latest_ubuntu.id
  instance_type   = var.instance_type
  security_groups = [element(var.security_groups, count.index)]
  subnet_id       = element(var.subnet_id, count.index)
  key_name        = "NAME OF KEY PAIR HAS BEEN DELETED"

  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_instance", {}))
}
