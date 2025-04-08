variable "vpc_id" {
  description = "VPC ID where the ALB will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "lb_name" {
  description = "Name for the ALB"
  type        = string
  default     = "my-alb"
}

variable "lb_security_groups" {
  description = "Security groups to attach to the ALB"
  type        = list(string)
  default     = []  # Pass in from root module
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "Prod"
}

variable "listener_port" {
  description = "Port on which the ALB listens"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol for the ALB listener"
  type        = string
  default     = "HTTP"
}

variable "target_group_name" {
  description = "Name for the target group"
  type        = string
  default     = "my-target-group"
}

variable "target_group_port" {
  description = "Port on which the target group receives traffic"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "target_type" {
  description = "Target type for the target group (instance or ip)"
  type        = string
  default     = "instance"
}

variable "health_check_path" {
  description = "Health check path for the target group"
  type        = string
  default     = "/"
}

variable "health_check_protocol" {
  description = "Protocol for health check"
  type        = string
  default     = "HTTP"
}

variable "health_check_interval" {
  description = "Interval (in seconds) for health checks"
  type        = number
  default     = 30
}

variable "healthy_threshold" {
  description = "Healthy threshold count"
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "Unhealthy threshold count"
  type        = number
  default     = 3
}

variable "create_security_group" {
  description = "Flag to create a new security group for the ALB"
  type        = bool
  default     = true
}
