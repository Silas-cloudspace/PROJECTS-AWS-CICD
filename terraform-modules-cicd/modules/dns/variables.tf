# DNS Module Variables

# Route53 Variables
variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "record_name" {
  description = "Subdomain record name"
  type        = string
}

# CloudFront Variables
variable "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  type        = string
}

variable "cloudfront_zone_id" {
  description = "The hosted zone ID of the CloudFront distribution"
  type        = string
}

# ALB Variables
variable "alb_dns_name" {
  description = "The DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "The zone ID of the ALB"
  type        = string
}