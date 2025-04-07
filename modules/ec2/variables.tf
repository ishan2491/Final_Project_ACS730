variable "vpc_prod" {
  description = "Name of the VPC"
  type        = string
  default     = "Prod-VPC"
}

variable "prod" {
  description = "Environment name"
  type        = string
  default     = "Prod"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

/*variable "bastion_key_name" {
  description = "Name of the SSH key pair for Bastion Host"
  type        = string
  default     = "bastion_key"
}

variable "web_key_name" {
  description = "Name of the SSH key pair for Web Servers"
  type        = string
  default     = "web_key"
}*/

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}

variable "target_group_arn" {
  description = "ARN of the target group for ALB"
  type        = string
  default     = ""
}
