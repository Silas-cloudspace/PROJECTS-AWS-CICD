# CloudFront ACM Certificate in us-east-1
resource "aws_acm_certificate" "cloudfront_certificate" {
  provider                  = aws.us_east_1
  domain_name               = var.domain_name
  subject_alternative_names = [var.alternative_names]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cloudfront_certificate_validation" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cloudfront_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cloudfront_record : record.fqdn]
}

# ALB ACM Certificate in eu-west-1
resource "aws_acm_certificate" "alb_certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = [var.alternative_names]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "alb_certificate_validation" {
  certificate_arn         = aws_acm_certificate.alb_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.alb_record : record.fqdn]
}
