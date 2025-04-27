# Layer 1: Core Infrastructure
# Network Module - fundamental networking infrastructure
module "network" {
  source = "../modules/network"

  # Project Variables
  project_name = var.project_name
  environment  = var.environment

  # VPC Variables
  vpc_cidr                    = var.vpc_cidr
  public_subnet_az1_cidr      = var.public_subnet_az1_cidr
  public_subnet_az2_cidr      = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr = var.private_app_subnet_az2_cidr
}

# Layer 2: Data Storage
# Data Module - S3 and DynamoDB
module "data" {
  source = "../modules/data"

  # Project Variables
  project_name = var.project_name
  environment  = var.environment

  # Network Variables - Passed from network module
  vpc_id                     = module.network.vpc_id
  private_route_table_az1_id = module.network.private_route_table_az1_id
  private_route_table_az2_id = module.network.private_route_table_az2_id
}

# Layer 3: Security
# Security Module - ACM, IAM, WAF
module "security" {
  source = "../modules/security"

  # Project Variables
  project_name = var.project_name
  environment  = var.environment

  # DNS Variables
  domain_name       = var.domain_name
  alternative_names = var.alternative_names

  # DynamoDB Variables - from Data module
  dynamodb_table_arn = module.data.dynamodb_table_arn

  # Provider configuration
  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

# Layer 4A: Compute
# Compute Module - ALB, ASG, EC2
module "compute" {
  source = "../modules/compute"

  # Project Variables
  project_name = var.project_name
  environment  = var.environment

  # Instance Variables
  instance_type = var.instance_type

  # Network Variables - from Network module
  vpc_id                    = module.network.vpc_id
  public_subnet_az1_id      = module.network.public_subnet_az1_id
  public_subnet_az2_id      = module.network.public_subnet_az2_id
  private_app_subnet_az1_id = module.network.private_app_subnet_az1_id
  private_app_subnet_az2_id = module.network.private_app_subnet_az2_id

  # Security Variables - from Network and Security modules
  alb_security_group_id     = module.network.alb_security_group_id
  asg_security_group_id     = module.network.asg_security_group_id
  ec2_instance_profile_name = module.security.ec2_instance_profile_name

  # Certificate Variables - from Security module
  alb_certificate_validation_arn = module.security.alb_certificate_validation_arn
}

# Layer 4B: Content Delivery
# CloudFront Module - Frontend Distribution
module "cloudfront" {
  source = "../modules/cloudfront"

  # Project Variables
  project_name = var.project_name
  environment  = var.environment

  # DNS Variables
  domain_name = var.domain_name
  record_name = var.record_name

  # S3 Variables - from Data module
  s3_bucket_id                   = module.data.s3_bucket_id
  s3_bucket_arn                  = module.data.s3_bucket_arn
  s3_bucket_regional_domain_name = module.data.s3_bucket_regional_domain_name
  s3_bucket_name                 = module.data.s3_bucket_name

  # Certificate Variables - from Security module
  cloudfront_certificate_arn = module.security.cloudfront_certificate_arn

  # WAF Variables - from Security module
  cloudfront_waf_arn = module.security.cloudfront_waf_arn
}

# Layer 5A: WAF Association
# WAF Association Module - Link WAF to ALB after both are created
module "waf_association" {
  source = "../modules/waf_association"

  alb_arn          = module.compute.alb_arn
  regional_waf_arn = module.security.regional_waf_arn
}

# Layer 5B: DNS
# DNS Module - Route53 records for frontend and API
module "dns" {
  source = "../modules/dns"

  # DNS Variables
  domain_name = var.domain_name
  record_name = var.record_name

  # CloudFront Variables - from CloudFront module
  cloudfront_domain_name = module.cloudfront.distribution_domain_name
  cloudfront_zone_id     = module.cloudfront.distribution_zone_id

  # ALB Variables - from Compute module
  alb_dns_name = module.compute.alb_dns_name
  alb_zone_id  = module.compute.alb_zone_id
}

# Layer 6: Monitoring
# Monitoring Module - CloudWatch and SNS
module "monitoring" {
  source = "../modules/monitoring"

  # Project Variables
  project_name = var.project_name
  environment  = var.environment

  # Email for Alerts
  email = var.email

  # ASG Variables - from Compute module
  asg_name = module.compute.asg_name

  # ALB Variables - from Compute module
  alb_arn_suffix = module.compute.alb_arn_suffix

  # Scaling Policy Variables - from Compute module
  scale_out_policy_arn = module.compute.scale_out_policy_arn
  scale_in_policy_arn  = module.compute.scale_in_policy_arn

  # DynamoDB Variables - from Data module
  dynamodb_table_name = module.data.dynamodb_table_name

  # CloudFront Variables - from CloudFront module
  cloudfront_distribution_id = module.cloudfront.distribution_id

  # S3 Variables - from Data module
  s3_bucket_name = module.data.s3_bucket_name
}