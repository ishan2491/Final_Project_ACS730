# Output VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# Output each public subnet individually for deterministic ordering
output "public_subnet_1" {
  description = "Public Subnet 1"
  value       = aws_subnet.public[0].id
}

output "public_subnet_2" {
  description = "Public Subnet 2"
  value       = aws_subnet.public[1].id
}

output "public_subnet_3" {
  description = "Public Subnet 3"
  value       = aws_subnet.public[2].id
}

output "public_subnet_4" {
  description = "Public Subnet 4"
  value       = aws_subnet.public[3].id
}

# (Optional) Output each private subnet individually as well
output "private_subnet_1" {
  description = "Private Subnet 1"
  value       = aws_subnet.private[0].id
}

output "private_subnet_2" {
  description = "Private Subnet 2"
  value       = aws_subnet.private[1].id
}

# Output Internet Gateway ID
output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.igw.id
}

# Output NAT Gateway IDs
output "nat_gateway_ids" {
  description = "List of NAT gateway IDs"
  value       = aws_nat_gateway.nat_gw[*].id
}

