# ALB security group
resource "aws_security_group" "alb_security_group" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Enable HTTP/HTTPS access on ports 80/443"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}

# ECS security group
resource "aws_security_group" "ecs_security_group" {
  name        = "${var.project_name}-${var.environment}-ecs-sg"
  description = "Allow HTTP traffic from ALB to fargate"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow HTTP traffic from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-app-sg"
  }
}

# Allow ECS tasks to communicate with DynamoDB via the VPC Endpoint
resource "aws_security_group_rule" "ecs_outbound_dynamodb" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ecs_security_group.id
  cidr_blocks       = [aws_vpc.vpc.cidr_block]  # Allow outbound traffic to VPC (includes DynamoDB)
}