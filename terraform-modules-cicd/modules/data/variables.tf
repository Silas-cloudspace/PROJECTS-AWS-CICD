# Project Variables
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

# Network Variables
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
} 

variable "private_route_table_az1_id" {
  description = "The ID of the private route table for AZ1"
  type        = string
}

variable "private_route_table_az2_id" {
  description = "The ID of the private route table for AZ2"
  type        = string
}