# Security Module Variables

# Project Variables
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

# DNS Variables
variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "alternative_names" {
  description = "Subject alternative names for certificates"
  type        = string
}

# DynamoDB Variables
variable "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table for IAM permissions"
  type        = string
  default     = ""  # Default empty to allow initial deployment
}