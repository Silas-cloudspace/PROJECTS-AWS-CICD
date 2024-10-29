# environment variables
region       = "eu-west-2"
project_name = "wheelsondemand"
environment  = "dev"

# vpc variables
vpc_cidr                     = "10.0.0.0/16"
public_subnet_az1_cidr       = "10.0.0.0/24"
public_subnet_az2_cidr       = "10.0.1.0/24"
private_app_subnet_az1_cidr  = "10.0.2.0/24"
private_app_subnet_az2_cidr  = "10.0.3.0/24"
private_data_subnet_az1_cidr = "10.0.4.0/24"
private_data_subnet_az2_cidr = "10.0.5.0/24"

# secrets manager variables
secrets_manager_secret_name = "whellsondemand-app-dev-secrets"

# rds variables
multi_az_deployment          = "false" # we are not creating a standby rds because of the extra cost
database_instance_identifier = "app-db"
database_instance_class      = "db.t3.medium"
publicly_accessible          = "false"

# acm variables
domain_name       = "cloudspace-consulting.com" # paste your domain name
alternative_names = "*.cloudspace-consulting.com"

# s3 variables
env_file_bucket_name = "whellsondemand-app-env-file-bucket" # pick a different name
env_file_name        = "env-variables-file.env"

# ecs variables
architecture = "X86_64"
image_name   = "whellsondemand-app"
image_tag    = "latest"

# route-53 variables
record_name = "www"
