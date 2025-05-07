provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "killy" {
  key_name = var.key_name
  public_key = file("/home/vaibhav-s-rajurkar/Downloads/chabi.pub")
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags={
    Name="Main-vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet_cidr
  availability_zone = var.availabilty_zone
  map_public_ip_on_launch = true
  tags = {
    Name="Subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name="IGW"
  }
}

resource "aws_route_table" "routeTable" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name="route-table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id = aws_subnet.subnet.id
  route_table_id = aws_route_table.routeTable.id
}

resource "aws_security_group" "allow_ssh" {
  name = "allow ssh"
  description = "allow ssh"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags={
    Name = "ssh"
  }

}

resource "aws_instance" "ec2" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet.id
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  associate_public_ip_address = true
  key_name = aws_key_pair.killy.key_name
  tags={
    Name = "EC2"
  }
}

output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
}
