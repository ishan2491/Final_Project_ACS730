# EC2 Module for Web Servers, Bastion Host, and Database Servers

# Reference the existing VPC
data "aws_vpc" "vpc" {
  id = var.vpc_id
}

# Discover existing public subnets via filters
data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Environment"
    values = [var.prod]
  }
  filter {
    name   = "tag:Name"
    values = ["Prod-VPC-PublicSubnet-*"]
  }
}

# Discover existing private subnets via filters
data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Environment"
    values = [var.prod]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_prod}-PrivateSubnet-*"]
  }
}

