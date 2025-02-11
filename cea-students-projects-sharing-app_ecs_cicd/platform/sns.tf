# SNS Topic for CloudWatch Alarms
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-${var.environment}-alerts-topic"
}

# SNS Topic Subscription (e.g., Email)
resource "aws_sns_topic_subscription" "alerts_subscription" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email" # Change this if needed (e.g., "lambda", "https")
  endpoint  = var.email
}
