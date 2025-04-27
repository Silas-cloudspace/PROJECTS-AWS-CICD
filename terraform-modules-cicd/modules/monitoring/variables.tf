# Project Variables
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

# Email for Alerts
variable "email" {
  description = "Email for receiving alerts"
  type        = string
}

# ASG Variables
variable "asg_name" {
  description = "The name of the Auto Scaling Group"
  type        = string
}

# ALB Variables
variable "alb_arn_suffix" {
  description = "The ARN suffix of the ALB"
  type        = string
}

# Scaling Policy Variables
variable "scale_out_policy_arn" {
  description = "The ARN of the scale out policy"
  type        = string
}

variable "scale_in_policy_arn" {
  description = "The ARN of the scale in policy"
  type        = string
}

# DynamoDB Variables
variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
}

# CloudFront Variables
variable "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  type        = string
}

# S3 Variables
variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}