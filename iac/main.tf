# Importing VPC and ECS local modules
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr_block = var.vpc_cidr_block
  public_subnet_count = var.public_subnet_count
  aws_region = var.aws_region
}

module "ecs" {
  source = "./modules/ecs"

  aws_region = var.aws_region
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.ecs_subnet_ids
  node_hello_task_family = var.node_hello_task_family
  node_hello_task_name = var.node_hello_task_name
  dockerhub_repo_url = var.dockerhub_repo_url
  ecs_task_execution_role_name = var.ecs_task_execution_role_name
  application_load_balancer_name = var.application_load_balancer_name
  target_group_name = var.target_group_name
  container_port = var.container_port
  new_relic_license_key = var.new_relic_license_key
}