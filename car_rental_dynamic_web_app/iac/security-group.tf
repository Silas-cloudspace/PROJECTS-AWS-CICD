# create security group for the application load balancer
resource "aws_security_group" "alb_security_group" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "enable http/https access on port 80/443"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https access"
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

# create security group for the self-hosted ec2 github runner
resource "aws_security_group" "runner_security_group" {
  name        = "${var.project_name}-${var.environment}-runner-sg"
  description = "enable only outbound https access on port 443"
  vpc_id      = aws_vpc.vpc.id

  # allow inbound traffic from the same security group on port 3306
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    self = true
  }

  # allow inbound traffic from the private subnet on port 3306
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [
      var.private_data_subnet_az1_cidr,
      var.private_data_subnet_az2_cidr
    ]
  }

  # allow outbound traffic to the private subnet on all ports
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [
      var.private_data_subnet_az1_cidr,
      var.private_data_subnet_az2_cidr
    ]
  }

  # allow outbound https traffic to any destination ip to access external resources
  egress {
    description = "https access"
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow outbound http traffic to any destination ip to access external resources
  egress {
    description = "http access"
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-runner-sg"
  }
}

# create security group for the app server
resource "aws_security_group" "app_server_security_group" {
  name        = "${var.project_name}-${var.environment}-app-server-sg"
  description = "enable http/https access on port 80/443 via alb sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "http access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description     = "https access"
    from_port       = 443
    to_port         = 443
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
    Name = "${var.project_name}-${var.environment}-app-server-sg"
  }
}

# create security group for the database
resource "aws_security_group" "database_security_group" {
  name        = "${var.project_name}-${var.environment}-database-sg"
  description = "enable mysql/aurora access on port 3306"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "mysql/aurora access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_server_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-database-sg"
  }
}
