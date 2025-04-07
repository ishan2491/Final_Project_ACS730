# Outputs for Public IPs of Web Servers
output "web_server_1_public_ip" {
  description = "Public IP of Web Server 1"
  value       = aws_instance.web_1.public_ip
}

output "web_server_3_public_ip" {
  description = "Public IP of Web Server 3"
  value       = aws_instance.web_3.public_ip
}

output "web_server_4_public_ip" {
  description = "Public IP of Web Server 4"
  value       = aws_instance.web_4.public_ip
}

# Outputs for Private IPs of Database Servers
output "database_server_5_private_ip" {
  description = "Private IP of Database Server 5"
  value       = aws_instance.db_5.private_ip
}

output "database_server_6_private_ip" {
  description = "Private IP of Database Server 6"
  value       = aws_instance.db_6.private_ip
}

output "web_asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.web_asg.name
}

output "bastion_host_id" {
  description = "ID of the Bastion Host"
  value       = aws_instance.bastion.id
}

