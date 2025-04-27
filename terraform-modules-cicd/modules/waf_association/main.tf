# WAF Association Module - handles WAF to ALB associations to prevent circular deps

# Associate Regional WAF with ALB
resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = var.alb_arn
  web_acl_arn  = var.regional_waf_arn
}