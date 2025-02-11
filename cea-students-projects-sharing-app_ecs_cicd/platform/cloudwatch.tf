# CloudWatch Log Groups (Stores Logs for ECS, ALB, CloudFront, DynamoDB)
# ECS Log Group (Used by ECS Task Definition)
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "${var.project_name}-${var.environment}-ecs-log-group"
  retention_in_days = 7

  lifecycle {
    create_before_destroy = true
  }
}

# ALB Log Group (Stores ALB Access Logs)
resource "aws_cloudwatch_log_group" "alb_log_group" {
  name              = "${var.project_name}-${var.environment}-alb-log-group"
  retention_in_days = 7

  lifecycle {
    create_before_destroy = true
  }
}

# CloudFront Log Group (Stores CloudFront Logs)
resource "aws_cloudwatch_log_group" "cloudfront_log_group" {
  name              = "${var.project_name}-${var.environment}-cloudfront-log-group"
  retention_in_days = 7

  lifecycle {
    create_before_destroy = true
  }
}

# DynamoDB Log Group (Stores DynamoDB Operational Logs)
resource "aws_cloudwatch_log_group" "dynamodb_log_group" {
  name              = "${var.project_name}-${var.environment}-dynamodb-log-group"
  retention_in_days = 7

  lifecycle {
    create_before_destroy = true
  }
}

# CloudWatch Log Streams (Used for ECS Task Logging)
resource "aws_cloudwatch_log_stream" "ecs_log_stream" {
  name           = "${var.project_name}-${var.environment}-ecs-log-stream"
  log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
}

# ECS CloudWatch Metrics and Alarms
# Monitors ECS CPU Utilization (Triggers when CPU exceeds 75%)
resource "aws_cloudwatch_metric_alarm" "ecs_high_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-ecs-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "Alarm if CPU usage exceeds 75% for 2 consecutive minutes"
  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
    ServiceName = aws_ecs_service.ecs_service.name
  }

  alarm_actions = ["${aws_sns_topic.alerts.arn}"]
}

# Monitors ECS Memory Utilization (Triggers when Memory exceeds 75%)
resource "aws_cloudwatch_metric_alarm" "ecs_high_memory" {
  alarm_name          = "${var.project_name}-${var.environment}-ecs-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "Alarm if memory usage exceeds 75% for 2 consecutive minutes"
  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
    ServiceName = aws_ecs_service.ecs_service.name
  }

  alarm_actions = ["${aws_sns_topic.alerts.arn}"]
}

# Ensures ECS Logs Are Being Written (Triggers if no logs are generated)
resource "aws_cloudwatch_metric_alarm" "ecs_log_failure" {
  alarm_name          = "${var.project_name}-${var.environment}-ecs-log-failure"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "IncomingLogEvents"
  namespace           = "AWS/Logs"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Warning: No logs generated for ECS tasks"
  dimensions = {
    LogGroupName = aws_cloudwatch_log_group.ecs_log_group.name
  }

  alarm_actions = ["${aws_sns_topic.alerts.arn}"]
}

# ALB CloudWatch Metrics and Alarms
# Monitors ALB 5XX errors (Threshold reduced to 20)
resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "${var.project_name}-${var.environment}-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 20
  alarm_description   = "Critical: ALB is generating too many 5XX errors"
  dimensions = {
    LoadBalancer = aws_lb.application_load_balancer.arn_suffix
  }

  alarm_actions = ["${aws_sns_topic.alerts.arn}"]
}

# Monitors ALB request count
resource "aws_cloudwatch_metric_alarm" "alb_request_count" {
  alarm_name          = "${var.project_name}-${var.environment}-alb-request-count"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 1000
  alarm_description   = "Warning: High ALB traffic detected"
  dimensions = {
    LoadBalancer = aws_lb.application_load_balancer.arn_suffix
  }

  alarm_actions = ["${aws_sns_topic.alerts.arn}"]
}

# CloudFront CloudWatch Metrics and Alarms
# Monitors CloudFront 4XX errors
resource "aws_cloudwatch_metric_alarm" "cloudfront_4xx_errors" {
  alarm_name          = "${var.project_name}-${var.environment}-cloudfront-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "4xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = 300
  statistic           = "Average"
  threshold           = 5
  alarm_description   = "Warning: CloudFront 4XX error rate exceeds 5%"
  dimensions = {
    DistributionId = aws_cloudfront_distribution.frontend.id
  }

  alarm_actions = ["${aws_sns_topic.alerts.arn}"]
}
