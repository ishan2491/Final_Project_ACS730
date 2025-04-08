# Optionally create a security group for the ALB if create_security_group is true.
resource "aws_security_group" "alb_sg" {
  count       = var.create_security_group ? 1 : 0
  name        = "${var.lb_name}-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.listener_port
    to_port     = var.listener_port
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
    Name        = "${var.lb_name}-sg"
    Environment = var.environment
  }
}

locals {
  # If the module creates its own SG, use it; otherwise, use any provided SG list.
  final_lb_security_groups = var.create_security_group ? [aws_security_group.alb_sg[0].id] : var.lb_security_groups
}

# Create an Application Load Balancer
resource "aws_lb" "this" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = local.final_lb_security_groups

  tags = {
    Name        = var.lb_name
    Environment = var.environment
  }
}

# Create a Target Group
resource "aws_lb_target_group" "this" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    path                = var.health_check_path
    protocol            = var.health_check_protocol
    interval            = var.health_check_interval
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = {
    Name        = var.target_group_name
    Environment = var.environment
  }
}

# Create a Listener for the ALB
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
