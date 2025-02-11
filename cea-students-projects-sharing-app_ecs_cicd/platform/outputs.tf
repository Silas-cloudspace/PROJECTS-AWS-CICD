output "frontend_s3_bucket" {
  description = "Frontend s3 bucket"
  value = aws_s3_bucket.frontend.id
}

output "api_domain_name" {
  description = "The full domain name for the API endpoint"
  value       = aws_route53_record.api_domain.name
}

output "website_url" {
  description = "The full domain name of the website"
  value       = "https://${var.record_name}.${var.domain_name}"
}