# CloudFront Outputs
output "distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.frontend.id
}

output "distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.frontend.arn
}

output "distribution_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.frontend.domain_name
}

output "distribution_zone_id" {
  description = "The hosted zone ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.frontend.hosted_zone_id
}

# OAI Outputs
output "origin_access_identity_path" {
  description = "The path of the CloudFront origin access identity"
  value       = aws_cloudfront_origin_access_identity.frontend.cloudfront_access_identity_path
}

output "origin_access_identity_id" {
  description = "The ID of the CloudFront origin access identity"
  value       = aws_cloudfront_origin_access_identity.frontend.id
}