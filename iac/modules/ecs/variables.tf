variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "node-hello-cluster"
}

variable "node_hello_task_family" {
  description = "Family name for the ECS task definition"
  type        = string
  default     = "node-hello-task" 
}

variable "node_hello_task_name" {
  description = "Name of the container in the ECS task"
  type        = string
  default     = "node-hello-container"
}

variable "dockerhub_repo_url" {
  description = "Docker Hub repository URL for the application"
  type        = string
  sensitive   = true
}

variable "ecs_task_execution_role_name" {
  description = "Name of the ECS task execution role"
  type        = string
  default     = "ecs_task_execution_role"
}

variable "application_load_balancer_name" {
  description = "Name of the application load balancer"
  type        = string
  default     = "ecs-alb"
}

variable "target_group_name" {
  description = "Name of the AWS load balancer target group"
  type        = string
  default     = "ecs-alb-tg"
}

variable "vpc_id" {
  description = "VPC ID for the ECS resources"
  type        = string
}

variable "container_port" {
  description = "Container port for the ECS task"
  type        = number
  default     = 3000
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "new_relic_license_key" {
  description = "New Relic license key"
  type        = string
  sensitive   = true
}