# provider.tf

# Default AWS Provider
provider "aws" {
  region = "your region"
}

# Aliased AWS Provider for us-east-1
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
