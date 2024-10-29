terraform {
  backend "s3" {
    bucket         = "wheelsondemand-state-bucket-st"
    key            = "wheelsondemand/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "wheelsondemand-state-lock-table-st"
  }
}
