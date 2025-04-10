output "web_server_1_public_ip" {
  description = "Public IP of Web Server 1"
  value       = module.ec2.web_server_1_public_ip
}

output "web_server_3_public_ip" {
  description = "Public IP of Web Server 3"
  value       = module.ec2.web_server_3_public_ip
}

output "web_server_4_public_ip" {
  description = "Public IP of Web Server 4"
  value       = module.ec2.web_server_4_public_ip
}

output "database_server_5_private_ip" {
  description = "Private IP of Database Server 5"
  value       = module.ec2.database_server_5_private_ip
}

output "database_server_6_private_ip" {
  description = "Private IP of Database Server 6"
  value       = module.ec2.database_server_6_private_ip
}

output "web_asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.ec2.web_asg_name
}

output "bastion_host_id" {
  description = "ID of the Bastion Host"
  value       = module.ec2.bastion_host_id
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "target_group_arn" {
  description = "Target Group ARN"
  value       = module.alb.target_group_arn
}

output "listener_arn" {
  description = "ALB Listener ARN"
  value       = module.alb.listener_arn
}
