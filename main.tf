terraform {
  backend "s3" {
    bucket  = "final-project-acs730-ishan"
    key     = "two-tier-app/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}

# Retrieve VPC outputs from the remote state of the previously applied VPC module
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "final-project-acs730-ishan"  # Same S3 bucket where the VPC state is stored
    key    = "vpc/terraform.tfstate"         # Path to the VPC state file
    region = "us-east-1"
  }
}

# Call EC2 Module using the VPC details obtained from remote state
module "ec2" {
  source = "./modules/ec2"

  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnets  = data.terraform_remote_state.vpc.outputs.public_subnets
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnets

  instance_type    = "t2.micro"
  min_size         = 1
  max_size         = 4
  desired_capacity = 2
  target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-target-group/1234567890abcdef"
}
