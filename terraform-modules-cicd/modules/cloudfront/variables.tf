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

variable "record_name" {
  description = "Record name for the frontend domain"
  type        = string
}

# S3 Variables
variable "s3_bucket_id" {
  description = "The ID of the S3 bucket"
  type        = string
}

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}

variable "s3_bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

# Certificate Variables
variable "cloudfront_certificate_arn" {
  description = "The ARN of the CloudFront certificate"
  type        = string
}

# WAF Variables
variable "cloudfront_waf_arn" {
  description = "The ARN of the CloudFront WAF"
  type        = string
}