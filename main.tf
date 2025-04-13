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

# Retrieve VPC outputs from the remote state of the previously applied VPC module.
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "final-project-acs730-ishan" # Same S3 bucket where the VPC state is stored
    key    = "vpc/terraform.tfstate"      # Path to the VPC state file
    region = "us-east-1"
  }
}

# Call EC2 Module using the VPC details obtained from remote state.
module "ec2" {
  source = "./modules/ec2"

  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  
  public_subnets = [
    data.terraform_remote_state.vpc.outputs.public_subnet_1,
    data.terraform_remote_state.vpc.outputs.public_subnet_2,
    data.terraform_remote_state.vpc.outputs.public_subnet_3,
    data.terraform_remote_state.vpc.outputs.public_subnet_4,
  ]

  private_subnets = [
    data.terraform_remote_state.vpc.outputs.private_subnet_1,
    data.terraform_remote_state.vpc.outputs.private_subnet_2,
  ]
  /*public_subnets  = data.terraform_remote_state.vpc.outputs.public_subnets
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnets*/

  instance_type    = "t2.micro"
  min_size         = 1
  max_size         = 4
  desired_capacity = 2
  target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-target-group/1234567890abcdef"
}

# Call ALB Module using the VPC outputs from remote state.
module "alb" {
  source                = "./modules/alb"
  vpc_id                = data.terraform_remote_state.vpc.outputs.vpc_id
  /*public_subnets        = data.terraform_remote_state.vpc.outputs.public_subnets*/
  public_subnets        = [
    data.terraform_remote_state.vpc.outputs.public_subnet_1,
    data.terraform_remote_state.vpc.outputs.public_subnet_2,
    data.terraform_remote_state.vpc.outputs.public_subnet_3,
    data.terraform_remote_state.vpc.outputs.public_subnet_4
  ]
  lb_name               = "ProdALB"
  environment           = "Prod"
  listener_port         = 80
  listener_protocol     = "HTTP"
  target_group_name     = "ProdTargetGroup"
  target_group_port     = 80
  target_group_protocol = "HTTP"
  target_type           = "instance"
  health_check_path     = "/"
  health_check_protocol = "HTTP"
  health_check_interval = 30
  healthy_threshold     = 3
  unhealthy_threshold   = 3
}

# Attach Web Server 1 and Web Server 3 to the ALB Target Group.
resource "aws_lb_target_group_attachment" "web_1_attachment" {
  target_group_arn = module.alb.target_group_arn
  target_id        = module.ec2.web_server_1_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_3_attachment" {
  target_group_arn = module.alb.target_group_arn
  target_id        = module.ec2.web_server_3_id
  port             = 80
}
