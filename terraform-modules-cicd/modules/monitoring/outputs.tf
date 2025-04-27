# SNS Topic Output
output "sns_topic_arn" {
  description = "The ARN of the SNS topic for alerts"
  value       = aws_sns_topic.alerts.arn
}

# CloudWatch Log Group Outputs
output "app_log_group_name" {
  description = "The name of the app CloudWatch log group"
  value       = aws_cloudwatch_log_group.app_log_group.name
}

output "asg_log_group_name" {
  description = "The name of the ASG CloudWatch log group"
  value       = aws_cloudwatch_log_group.asg_log_group.name
}

output "alb_log_group_name" {
  description = "The name of the ALB CloudWatch log group"
  value       = aws_cloudwatch_log_group.alb_log_group.name
}

output "cloudfront_log_group_name" {
  description = "The name of the CloudFront CloudWatch log group"
  value       = aws_cloudwatch_log_group.cloudfront_log_group.name
}