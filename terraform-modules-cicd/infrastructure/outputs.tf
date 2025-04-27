output "s3_bucket_name" {
  description = "The name of the S3 bucket for frontend deployment"
  value       = module.data.s3_bucket_name
}

output "api_domain_name" {
  description = "The full domain name for the API endpoint"
  value       = module.dns.api_domain_name
}

output "website_url" {
  description = "The full domain name of the website"
  value       = "https://${var.record_name}.${var.domain_name}"
}