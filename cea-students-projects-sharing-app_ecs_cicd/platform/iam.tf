# ECS Execution Role (Used by ECS Task Definition)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-${var.environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AmazonECSTaskExecutionRolePolicy (includes ECR & CloudWatch permissions)
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Role (Used by ECS tasks for application-level access)
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project_name}-${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Policy for ECS Task Role (Application-Level Permissions)
resource "aws_iam_policy" "ecs_task_policy" {
  name        = "${var.project_name}-${var.environment}-ecs-task-policy"
  description = "Grants ECS Task permissions to access required AWS services"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Allow ECS task to access the specific DynamoDB table
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "arn:aws:dynamodb:${var.region}:${var.aws_account_id}:table/projects"
      },
      # Allow ECS task to list DynamoDB tables (useful for troubleshooting)
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

# Attach Policy to Task Role
resource "aws_iam_role_policy_attachment" "ecs_task_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_policy.arn
}

# IAM Policy for GitHub Actions to Deploy Frontend to S3
resource "aws_iam_policy" "github_actions_s3_policy" {
  name        = "GitHubActionsS3Policy"
  description = "Policy to allow GitHub Actions to deploy frontend to S3"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.frontend.id}",
          "arn:aws:s3:::${aws_s3_bucket.frontend.id}/*"
        ]
      }
    ]
  })
}

# Attach the S3 Policy to the IAM User (GitHub Actions Service Account)
resource "aws_iam_user_policy_attachment" "github_actions_s3_attachment" {
  user       = var.aws_user_name
  policy_arn = aws_iam_policy.github_actions_s3_policy.arn
}
