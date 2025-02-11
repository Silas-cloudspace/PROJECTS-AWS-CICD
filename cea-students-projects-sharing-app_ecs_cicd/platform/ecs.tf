resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-${var.environment}-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "${var.project_name}-${var.environment}-td"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 2048
  memory                   = 4096

  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-${var.environment}-api"
      image     = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repository_name}:${var.image_tag}"
      cpu       = 2048
      memory    = 4096
      essential = true

      environment = [
        {
          name  = "AWS_REGION",
          value = var.region
        },
        {
          name  = "DYNAMODB_TABLE",
          value = aws_dynamodb_table.projects.name
        }
      ]

      portMappings = [
        {
          containerPort = 80
          hostport      = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = "${aws_cloudwatch_log_group.ecs_log_group.name}",
          "awslogs-region"        = "${var.region}",
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "ecs_service" {
  name                               = "${var.project_name}-${var.environment}-service"
  launch_type                        = "FARGATE"
  cluster                            = aws_ecs_cluster.ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.ecs_task_definition.arn
  platform_version                   = "LATEST"
  desired_count                      = 2
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  # Enable ECS managed tags and propagate tags from the service
  enable_ecs_managed_tags = false
  propagate_tags          = "SERVICE"

  # Networking Configuration
  network_configuration {
    subnets          = [aws_subnet.private_app_subnet_az1.id, aws_subnet.private_app_subnet_az2.id]
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = false
  }

  # Load Balancer Configuration
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = "${var.project_name}-${var.environment}-api"
    container_port   = 80
  }
}

# ECS Auto Scaling Target
resource "aws_appautoscaling_target" "ecs_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 1
  max_capacity       = 6
}

# ECS Auto Scaling Policies
# Scale Out Policy (Increase Tasks)
resource "aws_appautoscaling_policy" "ecs_scale_out" {
  name               = "${var.project_name}-${var.environment}-scale-out"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = 50.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_out_cooldown = 60
    scale_in_cooldown  = 60
  }
}

# Scale In Policy (Decrease Tasks) - Change to Memory Utilization
resource "aws_appautoscaling_policy" "ecs_scale_in" {
  name               = "${var.project_name}-${var.environment}-scale-in"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = 30.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    scale_out_cooldown = 60
    scale_in_cooldown  = 60
  }
} 