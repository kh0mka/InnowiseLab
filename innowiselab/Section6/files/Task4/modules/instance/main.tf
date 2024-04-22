data "aws_ami" "latest_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_eip" "web-srv-eip" {
  count = var.instance_count

  instance = element(aws_instance.instance_of_web_server.*.id, count.index)
  domain   = "vpc"
}

resource "aws_instance" "instance_of_web_server" {
  count = var.instance_count

  ami                         = data.aws_ami.latest_ubuntu.id
  associate_public_ip_address = true
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = element(var.subnet_id, count.index)
  user_data                   = var.userdata_file
  user_data_replace_on_change = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_web_instance", {}))
}
