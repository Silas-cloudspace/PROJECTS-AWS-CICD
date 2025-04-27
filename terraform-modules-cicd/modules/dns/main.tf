# Route53 Records Module

# Get hosted zone details
data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

# Frontend Route traffic through CloudFront
resource "aws_route53_record" "frontend_domain" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

# Backend Route traffic directly to the ALB
resource "aws_route53_record" "api_domain" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}