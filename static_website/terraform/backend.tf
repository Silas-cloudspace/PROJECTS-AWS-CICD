# Create the backend
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-st"
    key            = "website/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "state-lock-table-st"
  }
}
