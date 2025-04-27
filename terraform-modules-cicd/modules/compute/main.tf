# AMI Data Source
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# Application Load Balancer
resource "aws_lb" "application_load_balancer" {
  name                       = "${var.project_name}-${var.environment}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_security_group_id]
  subnets                    = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "alb_tg" {
  name        = "${var.project_name}-${var.environment}-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 15
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 3
  }
}

# HTTP Listener with Redirect Action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener with Forward Action
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_certificate_validation_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

# Launch Template for Auto Scaling Group
resource "aws_launch_template" "app_launch_template" {
  name          = "${var.project_name}-${var.environment}-launch-template"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  description   = "launch template for asg"

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [var.asg_security_group_id]

  iam_instance_profile {
    name = var.ec2_instance_profile_name
  }

  user_data = base64encode(templatefile("${path.module}/userdata.tpl", {
    ENVIRONMENT = var.environment,
    backend_main_py = file("${path.root}/../backend/main.py"),
    backend_requirements = file("${path.root}/../backend/requirements.txt")
  }))
}

# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [var.private_app_subnet_az1_id, var.private_app_subnet_az2_id]
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1
  name                = "${var.project_name}-${var.environment}-asg"
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-asg"
    propagate_at_launch = true
  }
}

# Auto Scaling Group Attachment to Target Group
resource "aws_autoscaling_attachment" "asg_alb_target_group_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.alb_tg.arn
}

# Scale Out Policy
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.project_name}-${var.environment}-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

# Scale In Policy
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.project_name}-${var.environment}-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}