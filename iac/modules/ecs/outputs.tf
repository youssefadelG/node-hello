
output "aws_region" {
  description = "The AWS region where resources are deployed"
  value       = var.aws_region
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.node_hello_cluster.name
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.node_hello_service.name
}

output "service_id" {
  description = "ID of the ECS service"
  value       = aws_ecs_service.node_hello_service.id
}

output "ecs_alb_dns_url" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_alb.application_load_balancer.dns_name
}

output "security_group_ids" {
  description = "IDs of the security groups associated with the ECS service"
  value       = [aws_security_group.ecs_service_sg.id, aws_security_group.alb_sg.id]
}