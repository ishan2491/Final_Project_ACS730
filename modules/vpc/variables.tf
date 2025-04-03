# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16" # Adjust as needed
}

variable "vpc_prod" {
  description = "Name of the VPC"
  type        = string
  default     = "Prod-VPC"
}

variable "prod" {
  description = "Prod"
  type        = string
  default     = "Prod"
}

# Subnet Configuration
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.1.5.0/24", "10.1.6.0/24"]
}

# Availability Zones
variable "availability_zones" {
  description = "List of availability zones to deploy resources"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}
