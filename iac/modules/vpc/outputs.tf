output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.ecs_vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.ecs_vpc.cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

# Subnet Outputs
output "ecs_subnet_ids" {
  description = "IDs of the ECS subnets"
  value       = aws_subnet.ecs_subnet[*].id
}

output "ecs_subnet_cidr_blocks" {
  description = "CIDR blocks of the ECS subnets"
  value       = aws_subnet.ecs_subnet[*].cidr_block
}

output "ecs_subnet_azs" {
  description = "Availability zones of the ECS subnets"
  value       = aws_subnet.ecs_subnet[*].availability_zone
}