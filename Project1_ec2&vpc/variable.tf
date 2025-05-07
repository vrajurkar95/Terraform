variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "route_cidr" {
  default = "0.0.0.0/0"
}

variable "availabilty_zone" {
  default = "us-east-1a"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default="ami-07d0b24681d011c7d"
}

variable "key_name" {
  default = "chabi"
}
