resource "aws_vpc" "myvpc" {
    cidr_block = var.vpc_cidr
}
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.public_sb_cidr
    map_public_ip_on_launch = true
    tags = {
      "Name" = "FlaskApp Subnet"
    }
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
      "Name" = "igw"
    }
}
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.myvpc.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
}
resource "aws_route_table_association" "public_rt_assoc" {
    route_table_id = aws_route_table.public_rt.id
    subnet_id = aws_subnet.public_subnet.id
}