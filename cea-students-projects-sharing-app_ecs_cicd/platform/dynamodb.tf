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
  vpc_id            = aws_vpc.vpc.id
  service_name      = data.aws_vpc_endpoint_service.dynamodb.service_name
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.private_route_table_az1.id,
    aws_route_table.private_route_table_az2.id
  ]
}
