# Network Module Outputs

# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

# Subnet Outputs
output "public_subnet_az1_id" {
  description = "The ID of the public subnet in AZ1"
  value       = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2_id" {
  description = "The ID of the public subnet in AZ2"
  value       = aws_subnet.public_subnet_az2.id
}

output "private_app_subnet_az1_id" {
  description = "The ID of the private app subnet in AZ1"
  value       = aws_subnet.private_app_subnet_az1.id
}

output "private_app_subnet_az2_id" {
  description = "The ID of the private app subnet in AZ2"
  value       = aws_subnet.private_app_subnet_az2.id
}

# Route Table Outputs
output "private_route_table_az1_id" {
  description = "The ID of the private route table for AZ1"
  value       = aws_route_table.private_route_table_az1.id
}

output "private_route_table_az2_id" {
  description = "The ID of the private route table for AZ2"
  value       = aws_route_table.private_route_table_az2.id
}

# Security Group Outputs
output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb_security_group.id
}

output "asg_security_group_id" {
  description = "The ID of the ASG security group"
  value       = aws_security_group.asg_security_group.id
}