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

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Security Group for Web Servers
resource "aws_security_group" "web_sg" {
  name        = "${var.vpc_prod}-WebServer-SG"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.vpc_prod}-WebServer-SG"
    Environment = var.prod
  }
}


