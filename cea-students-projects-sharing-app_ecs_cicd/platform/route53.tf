# Get hosted zone details
data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

# Route 53 record for CloudFront validation
resource "aws_route53_record" "cloudfront_record" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
}

# Route 53 record for ALB validation
resource "aws_route53_record" "alb_record" {
  for_each = {
    for dvo in aws_acm_certificate.alb_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
}

# Frontend Route traffic through CloudFront:
resource "aws_route53_record" "frontend_domain" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.frontend.domain_name
    zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}

# Backend Route traffic directly to the ALB:
resource "aws_route53_record" "api_domain" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.application_load_balancer.dns_name
    zone_id                = aws_lb.application_load_balancer.zone_id
    evaluate_target_health = true
  }
}

