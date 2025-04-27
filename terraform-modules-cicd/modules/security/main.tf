# Security Module - ACM Certificates, IAM, and WAF

# ACM Certificates
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

# ALB ACM Certificate in current region
resource "aws_acm_certificate" "alb_certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = [var.alternative_names]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Route53 zone data
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

# Certificate validations
resource "aws_acm_certificate_validation" "cloudfront_certificate_validation" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cloudfront_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cloudfront_record : record.fqdn]
}

resource "aws_acm_certificate_validation" "alb_certificate_validation" {
  certificate_arn         = aws_acm_certificate.alb_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.alb_record : record.fqdn]
}

# IAM Resources
# EC2 IAM Role
resource "aws_iam_role" "ec2_combined_role" {
  name = "${var.project_name}-${var.environment}-combined-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for DynamoDB Access
resource "aws_iam_policy" "dynamodb_access" {
  name        = "${var.project_name}-${var.environment}-dynamodb-access"
  description = "Allows EC2 instances to access DynamoDB"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:Scan",
          "dynamodb:DeleteItem"
        ]
        Resource = var.dynamodb_table_arn != "" ? [var.dynamodb_table_arn] : ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:ListTables"
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM Policy for CloudWatch Logs
resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "${var.project_name}-${var.environment}-cloudwatch-logs-policy"
  description = "Allows EC2 instances to publish logs to CloudWatch"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Attach DynamoDB Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "attach_dynamodb_policy" {
  role       = aws_iam_role.ec2_combined_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}

# Attach CloudWatch Logs Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_logs_policy" {
  role       = aws_iam_role.ec2_combined_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

# Attach SSM Managed Policy for EC2 Role
resource "aws_iam_role_policy_attachment" "ssm_core_policy" {
  role       = aws_iam_role.ec2_combined_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# EC2 Instance Profile
resource "aws_iam_instance_profile" "ec2_combined_profile" {
  name = "${var.project_name}-${var.environment}-combined-profile"
  role = aws_iam_role.ec2_combined_role.name
}

# WAF Resources
# Regional WAF (for ALB)
resource "aws_wafv2_web_acl" "regional" {
  name        = "${var.project_name}-${var.environment}-regional-web-acl"
  description = "WAF for protecting ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "SQLInjectionRule"
    priority = 1

    action {
      block {}
    }

    statement {
      sqli_match_statement {
        field_to_match {
          query_string {}
        }
        text_transformation {
          priority = 1
          type     = "URL_DECODE"
        }
        text_transformation {
          priority = 2
          type     = "HTML_ENTITY_DECODE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLInjectionRule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "XSSRule"
    priority = 2

    action {
      block {}
    }

    statement {
      xss_match_statement {
        field_to_match {
          body {}
        }
        text_transformation {
          priority = 1
          type     = "NONE"
        }
        text_transformation {
          priority = 2
          type     = "HTML_ENTITY_DECODE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "XSSRule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "regionalWebACL"
    sampled_requests_enabled   = true
  }
}

# CloudFront WAF (Global)
resource "aws_wafv2_web_acl" "cloudfront" {
  provider    = aws.us_east_1
  name        = "${var.project_name}-${var.environment}-cloudfront-web-acl"
  description = "WAF for protecting CloudFront"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "SQLInjectionRule"
    priority = 1

    action {
      block {}
    }

    statement {
      sqli_match_statement {
        field_to_match {
          query_string {}
        }
        text_transformation {
          priority = 1
          type     = "URL_DECODE"
        }
        text_transformation {
          priority = 2
          type     = "HTML_ENTITY_DECODE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLInjectionRule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "XSSRule"
    priority = 2

    action {
      block {}
    }

    statement {
      xss_match_statement {
        field_to_match {
          body {}
        }
        text_transformation {
          priority = 1
          type     = "NONE"
        }
        text_transformation {
          priority = 2
          type     = "HTML_ENTITY_DECODE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "XSSRule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cloudfrontWebACL"
    sampled_requests_enabled   = true
  }
}