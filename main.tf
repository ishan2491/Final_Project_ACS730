terraform {
  backend "s3" {
    bucket  = "final-project-acs730-ishan"
    key     = "two-tier-app/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

