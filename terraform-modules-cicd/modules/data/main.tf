# S3 Resources
resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project_name}-${var.environment}-bucket-st"
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Website Configuration for S3 Bucket
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }
}

# DynamoDB Table for Projects
resource "aws_dynamodb_table" "projects" {
  name         = "projects"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "projects"
  }
}

# Data source to dynamically fetch the service name for DynamoDB
data "aws_vpc_endpoint_service" "dynamodb" {
  service      = "dynamodb"
  service_type = "Gateway"
}

# VPC Endpoint for DynamoDB
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.dynamodb.service_name
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    var.private_route_table_az1_id,
    var.private_route_table_az2_id
  ]
}