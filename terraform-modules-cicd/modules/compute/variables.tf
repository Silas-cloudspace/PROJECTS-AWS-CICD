# Project Variables
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

# Instance Variables
variable "instance_type" {
  description = "Instance type"
  type        = string
}

# Network Variables
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_az1_id" {
  description = "The ID of the public subnet in AZ1"
  type        = string
}

variable "public_subnet_az2_id" {
  description = "The ID of the public subnet in AZ2"
  type        = string
}

variable "private_app_subnet_az1_id" {
  description = "The ID of the private app subnet in AZ1"
  type        = string
}

variable "private_app_subnet_az2_id" {
  description = "The ID of the private app subnet in AZ2"
  type        = string
}

# Security Variables
variable "alb_security_group_id" {
  description = "The ID of the ALB security group"
  type        = string
}

variable "asg_security_group_id" {
  description = "The ID of the ASG security group"
  type        = string
}

variable "ec2_instance_profile_name" {
  description = "The name of the EC2 instance profile"
  type        = string
}

# Certificate Variables
variable "alb_certificate_validation_arn" {
  description = "The ARN of the validated ALB certificate"
  type        = string
}