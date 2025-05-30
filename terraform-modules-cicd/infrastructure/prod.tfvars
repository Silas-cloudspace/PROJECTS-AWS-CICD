# Environment Variables
region       = "eu-west-1"
project_name = "cea-projects"
environment  = "prod"

# VPC Variables
vpc_cidr                    = "10.2.0.0/16"
public_subnet_az1_cidr      = "10.2.0.0/24"
public_subnet_az2_cidr      = "10.2.1.0/24"
private_app_subnet_az1_cidr = "10.2.2.0/24"
private_app_subnet_az2_cidr = "10.2.3.0/24"

# ASG Variables
instance_type = "t2.micro"

# Route53 Variables
domain_name       = "craftablecloud.com"
alternative_names = "*.craftablecloud.com"
record_name       = "www"

# SNS Variables
email = "cloudspace.silas@gmail.com"