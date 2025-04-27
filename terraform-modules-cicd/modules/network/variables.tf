# Network Module Variables

# Project Variables
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

# VPC Variables
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_az1_cidr" {
  description = "Public subnet AZ1 CIDR block"
  type        = string
}

variable "public_subnet_az2_cidr" {
  description = "Public subnet AZ2 CIDR block"
  type        = string
}

variable "private_app_subnet_az1_cidr" {
  description = "Private app subnet AZ1 CIDR block"
  type        = string
}

variable "private_app_subnet_az2_cidr" {
  description = "Private app subnet AZ2 CIDR block"
  type        = string
}