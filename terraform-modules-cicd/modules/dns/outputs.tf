# DNS Module Outputs

output "api_domain_name" {
  description = "The full domain name for the API endpoint"
  value       = aws_route53_record.api_domain.name
}