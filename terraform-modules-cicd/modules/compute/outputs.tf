# ALB Outputs
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.application_load_balancer.dns_name
}

output "alb_zone_id" {
  description = "The zone ID of the ALB"
  value       = aws_lb.application_load_balancer.zone_id
}

output "alb_arn" {
  description = "The ARN of the ALB"
  value       = aws_lb.application_load_balancer.arn
}

output "alb_arn_suffix" {
  description = "The ARN suffix of the ALB"
  value       = aws_lb.application_load_balancer.arn_suffix
}

# ASG Outputs
output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.name
}

output "asg_id" {
  description = "The ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.id
}

# Scaling Policy Outputs
output "scale_out_policy_arn" {
  description = "The ARN of the scale out policy"
  value       = aws_autoscaling_policy.scale_out.arn
}

output "scale_in_policy_arn" {
  description = "The ARN of the scale in policy"
  value       = aws_autoscaling_policy.scale_in.arn
}