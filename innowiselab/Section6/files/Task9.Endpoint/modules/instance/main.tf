
data "aws_ami" "getLatestUbuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "createInstances" {
  count = var.instance_count

  ami           = data.aws_ami.getLatestUbuntu.id
  instance_type = length(var.instance_type) > 1 ? element(var.instance_type, count.index) : var.instance_type[0]

  availability_zone = length(var.azs) > 1 ? element(var.azs, count.index) : var.azs[0]
  subnet_id         = element(var.subnet_ids, count.index)
  key_name          = length(var.key_name) > 1 ? element(var.key_name, count.index) : var.key_name[0]
  security_groups   = [element(var.security_groups, count.index)]

  tags = merge(
    {
      Name = try(
        var.names[count.index],
        format("%s", element(var.azs, count.index))
      )
    },
    var.tags,
    var.instance_tags,
    lookup(var.instance_tags_per_az, element(var.azs, count.index), {})
  )
}
