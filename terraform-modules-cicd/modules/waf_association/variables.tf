# WAF Association Module Variables

variable "alb_arn" {
  description = "The ARN of the ALB to associate with WAF"
  type        = string
}

variable "regional_waf_arn" {
  description = "The ARN of the regional WAF"
  type        = string
}