# environment variables
aws_account_id = "<your aws account id>"
region       = "<your region>"
project_name = "cea-projects"
environment  = "dev"

# vpc variables
vpc_cidr                    = "10.0.0.0/16"
public_subnet_az1_cidr      = "10.0.0.0/24"
public_subnet_az2_cidr      = "10.0.1.0/24"
private_app_subnet_az1_cidr = "10.0.2.0/24"
private_app_subnet_az2_cidr = "10.0.3.0/24"

# IAM variable
aws_user_name = "<your aws iam username>"

# ECS variables
ecr_repository_name = "cea-projects-sharing-ecr" # It needs to be the same name you will use in deploy.yaml file
image_tag = "latest" # It needs to be the same name you will use in deploy.yaml file

# route53 variables
domain_name       = "<your domain name>"
alternative_names = "*.<your domain name>"
record_name       = "www"

# SNS variables
email = "<your email>"