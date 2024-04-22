resource "aws_security_group" "sg" {
  count = length(var.vpc_id)

  vpc_id = element(var.vpc_id, count.index)

  dynamic "ingress" {
    for_each = {
      ping_icmp = {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["172.16.0.0/16", "172.17.0.0/16"]
      },
      ssh_tcp = {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
    }

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_sg", {}))
}
