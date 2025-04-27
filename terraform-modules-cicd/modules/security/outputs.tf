# Security Module Outputs

# Certificate Outputs
output "cloudfront_certificate_arn" {
  description = "The ARN of the CloudFront certificate"
  value       = aws_acm_certificate.cloudfront_certificate.arn
}

output "alb_certificate_arn" {
  description = "The ARN of the ALB certificate"
  value       = aws_acm_certificate.alb_certificate.arn
}

output "cloudfront_certificate_validation_arn" {
  description = "The ARN of the validated CloudFront certificate"
  value       = aws_acm_certificate_validation.cloudfront_certificate_validation.certificate_arn
}

output "alb_certificate_validation_arn" {
  description = "The ARN of the validated ALB certificate"
  value       = aws_acm_certificate_validation.alb_certificate_validation.certificate_arn
}

# IAM Outputs
output "ec2_instance_profile_name" {
  description = "The name of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2_combined_profile.name
}

output "ec2_role_name" {
  description = "The name of the EC2 IAM role"
  value       = aws_iam_role.ec2_combined_role.name
}

# WAF Outputs
output "cloudfront_waf_arn" {
  description = "The ARN of the CloudFront WAF"
  value       = aws_wafv2_web_acl.cloudfront.arn
}

output "regional_waf_arn" {
  description = "The ARN of the regional WAF"
  value       = aws_wafv2_web_acl.regional.arn
}