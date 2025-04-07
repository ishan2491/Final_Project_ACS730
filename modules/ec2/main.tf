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

# Web Server 1
resource "aws_instance" "web_1" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.public_subnets.ids[3]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "web_key"

  user_data = <<-EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
    systemctl enable httpd.service
    echo "<html><h1>Welcome to VM1 Web Page</h1></html>" > /var/www/html/index.html
  EOF

  tags = {
    Name        = "${var.vpc_prod}-WebServer-1"
    Environment = var.prod
  }
}

# Bastion Host (VM2)
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.public_subnets.ids[2]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "bastion_key"

  user_data = <<-EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
    systemctl enable httpd.service
    echo "<html><h1>Welcome to VM2 Bastion Host</h1></html>" > /var/www/html/index.html
  EOF

  tags = {
    Name        = "${var.vpc_prod}-BastionHost"
    Environment = var.prod
  }
}

# Web Server 3
resource "aws_instance" "web_3" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.public_subnets.ids[1]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "web_key"

  user_data = <<-EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
    systemctl enable httpd.service
    echo "<html><h1>Welcome to VM3 Web Page</h1></html>" > /var/www/html/index.html
  EOF

  tags = {
    Name        = "${var.vpc_prod}-WebServer-3"
    Environment = var.prod
  }
}

# Web Server 4
resource "aws_instance" "web_4" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.public_subnets.ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "web_key"

  user_data = <<-EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
    systemctl enable httpd.service
    echo "<html><h1>Welcome to VM4 Web Page</h1></html>" > /var/www/html/index.html
  EOF

  tags = {
    Name        = "${var.vpc_prod}-WebServer-4"
    Environment = var.prod
  }
}

# Database Server 5 (Private Subnet)
resource "aws_instance" "db_5" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.private_subnets.ids[1]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "bastion_key"

  tags = {
    Name        = "${var.vpc_prod}-DatabaseServer-5"
    Environment = var.prod
  }
}

# Database Server 6 (Private Subnet)
resource "aws_instance" "db_6" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.private_subnets.ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "bastion_key"

  tags = {
    Name        = "${var.vpc_prod}-DatabaseServer-6"
    Environment = var.prod
  }
}

# Auto Scaling Launch Configuration for Web Servers
resource "aws_launch_configuration" "web_lc" {
  name            = "${var.vpc_prod}-WebServer-LC"
  image_id        = data.aws_ami.amazon_linux_2.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.web_sg.id]
  key_name               = "web_key"

  user_data = <<-EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
    systemctl enable httpd.service
    echo "<html><h1>Welcome to Auto Scaling Group Web Page</h1></html>" > /var/www/html/index.html
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group for Web Servers
resource "aws_autoscaling_group" "web_asg" {
  name                 = "${var.vpc_prod}-WebServer-ASG"
  launch_configuration = aws_launch_configuration.web_lc.id
  vpc_zone_identifier  = data.aws_subnets.public_subnets.ids
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity

  tag {
    key                 = "Name"
    value               = "${var.vpc_prod}-WebServer-ASG"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.prod
    propagate_at_launch = true
  }
}


resource "aws_key_pair" "bastion" {
  key_name   = "bastion_key"
  public_key = file("${path.module}/bastion_key.pub")
}


resource "aws_key_pair" "web" {
  key_name   = "web_key"
  public_key = file("${path.module}/web_key.pub")
}

