# store the parsed secret value in a local variable for easier reference
locals {
  secrets = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)
}
