# create ecs cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

# create cloudwatch log group
resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/${var.project_name}-${var.environment}-td"

  lifecycle {
    create_before_destroy = true
  }
}

# create task definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "${var.project_name}-${var.environment}-td"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 2048
  memory                   = 4096

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = var.architecture
  }

  # create container definition
  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-${var.environment}-container"
      image     = "${local.secrets.ecr_registry}/${var.image_name}:${var.image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]

      environmentFiles = [
        {
          value = "arn:aws:s3:::${var.project_name}-${var.env_file_bucket_name}/${var.env_file_name}"
          type  = "s3"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = "${aws_cloudwatch_log_group.log_group.name}",
          "awslogs-region"        = "${var.region}",
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# create ecs service
resource "aws_ecs_service" "ecs_service" {
  name                               = "${var.project_name}-${var.environment}-service"
  launch_type                        = "FARGATE"
  cluster                            = aws_ecs_cluster.ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.ecs_task_definition.arn
  platform_version                   = "LATEST"
  desired_count                      = 2
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  # task tagging configuration
  enable_ecs_managed_tags = false
  propagate_tags          = "SERVICE"

  # vpc and security groups
  network_configuration {
    subnets          = [aws_subnet.private_app_subnet_az1.id, aws_subnet.private_app_subnet_az2.id]
    security_groups  = [aws_security_group.app_server_security_group.id]
    assign_public_ip = false
  }

  # load balancing
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    container_name   = "${var.project_name}-${var.environment}-container"
    container_port   = 80
  }
}
