output "aws_region" {
  description = "The AWS region where resources are deployed"
  value       = var.aws_region
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "load_balancer_url" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.ecs.ecs_alb_dns_url
}

output "application_url" {
  description = "HTTP URL to access the application"
  value       = "http://${module.ecs.ecs_alb_dns_url}"
}

output "container_count" {
  description = "Number of containers running in the ECS service"
  value       = 2
}

output "vpc_id" {
  description = "The ID of the VPC where resources are deployed"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs where ECS tasks are running"
  value       = module.vpc.ecs_subnet_ids
}