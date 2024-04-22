# Creating IGW and attach to VPC ID
resource "aws_internet_gateway" "main_igw" {
  vpc_id = var.vpc_id_for_igw

  tags = {
    Name = var.igw_name
  }
}
