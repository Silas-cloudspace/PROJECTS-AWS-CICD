# Environment Variables
variable "region" {
  description = "Region to create resources"
  type        = string
}

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

# ASG Variables
variable "instance_type" {
  description = "Instance type"
  type        = string
}

# Route53 Variables
variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "alternative_names" {
  description = "Subject alternative names for certificates"
  type        = string
}

variable "record_name" {
  description = "Subdomain record name"
  type        = string
}

# SNS Variables
variable "email" {
  description = "Email for receiving alerts"
  type        = string
}