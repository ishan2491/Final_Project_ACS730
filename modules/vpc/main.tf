# Configure Terraform Backend
terraform {
  backend "s3" {
    bucket         = "final-project-acs730-ishan"
    key            = "vpc/terraform.tfstate"
    region         = "us-east-1"
  }
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = var.vpc_prod
    Environment = var.prod
  }
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.vpc_prod}-PublicSubnet-${count.index + 1}"
    Environment = var.prod
  }
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.vpc_prod}-PrivateSubnet-${count.index + 1}"
    Environment = var.prod
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.vpc_prod}-IGW"
    Environment = var.prod
  }
}

# Elastic IPs for NAT Gateway
resource "aws_eip" "nat_eip" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"

  tags = {
    Name        = "${var.vpc_prod}-NATEIP-${count.index + 1}"
    Environment = var.prod
  }
}

# NAT Gateways for Private Subnets Internet Access
resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name        = "${var.vpc_prod}-NATGateway-${count.index + 1}"
    Environment = var.prod
  }
}

# Public Route Table and Routes
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.vpc_prod}-PublicRT"
    Environment = var.prod
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_rta" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Tables and Routes (using NAT Gateway)
resource "aws_route_table" "private_rt" {
  count          = length(var.private_subnet_cidrs)
  vpc_id         = aws_vpc.main.id

  tags = {
    Name        = "${var.vpc_prod}-PrivateRT-${count.index + 1}"
    Environment = var.prod
  }
}

resource "aws_route" "private_nat_access" {
  count                = length(var.private_subnet_cidrs)
  route_table_id       = aws_route_table.private_rt[count.index].id # Correct reference to private route table with index.
  destination_cidr_block   ="0.0.0.0/0"
 nat_gateway_id       ="${aws_nat_gateway.nat_gw[count.index].id}" # Correct reference to NAT Gateway with index.
}

resource "aws_route_table_association" "private_rta" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id # Correct reference to private subnet with index.
 route_table_id=aws_route_table.private_rt[count.index].id # Correct reference to private route table with index.
}
