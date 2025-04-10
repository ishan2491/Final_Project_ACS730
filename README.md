# Final Project: Two-Tier Web Application Automation

This repository contains the code for provisioning and configuring a two-tier web application using:
- **Terraform** for infrastructure as code (VPC, EC2, ALB, Auto Scaling, etc.)
- **Ansible** for configuration management of specific web servers
- **GitHub Actions** for automated CI/CD and security scans

## Pre-requisites

### AWS Account & Permissions
- Ensure you have access to an AWS account with permissions to create and manage resources such as S3 buckets, EC2 instances, ALB, and IAM roles.
- If using a college-provided AWS account, verify with your administrator that you have the necessary permissions.

### Remote Terraform State (S3 Bucket)
- **Purpose:** Store Terraform state files securely.
- **Action:** Create an S3 bucket.  
  Example (using AWS CLI):
  ```bash
  aws s3 mb s3://final-project-acs730-yourname --region us-east-1

### Configuration:
In the root module’s `main.tf`, configure the backend as follows:

```hcl
terraform {
  backend "s3" {
    bucket  = "final-project-acs730-yourname"
    key     = "two-tier-app/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

### Website Images (S3 Bucket for Images)
- **Purpose:** Store images to be displayed on the website.
- **Action:** Create a separate S3 bucket for images, ensuring it is not public.

  _Example:_
  ```bash
  aws s3 mb s3://your-website-images-bucket --region us-east-1

SSH Key Pairs
Purpose: Securely access your EC2 instances.

Action: Generate key pairs locally (do not commit private keys to the repository).

bash
Copy
ssh-keygen -t rsa -b 2048 -f bastion_key.pem
ssh-keygen -t rsa -b 2048 -f web_key.pem
Usage: The corresponding public keys (bastion_key.pem.pub, web_key.pem.pub) are referenced in the Terraform code.

Security: Make sure your private keys are added to your .gitignore so they are not tracked or pushed.

AWS Credentials for CI/CD
For GitHub Actions:
Since you’re using GitHub Actions to run Terraform, store your AWS credentials (or temporary session credentials) as repository secrets:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

AWS_SESSION_TOKEN (if using temporary credentials)

Configuration in Workflow:
The GitHub Actions workflow uses these secrets:

yaml
Copy
- name: Configure AWS credentials using static secrets
  uses: aws-actions/configure-aws-credentials@v2
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-session-token: ${{ secrets.AWS_SESSION_TOKEN }}
    aws-region: us-east-1
Deployment Process
Step 1: Deploy VPC Module
Navigate to the VPC Module Directory:

bash
Copy
cd modules/vpc
Initialize and Apply:

bash
Copy
terraform init
terraform apply -auto-approve
This creates your VPC, subnets, NAT gateway, etc.

Ensure that the VPC module outputs (e.g., vpc_id, public_subnets, private_subnets) are properly stored in the S3 backend as expected.

Step 2: Deploy Root Module
After the VPC is deployed and the state is available, return to the root module directory (which references the remote state):

Navigate Back to the Root Module Directory:

bash
Copy
cd ../../   # or navigate manually to the root directory containing main.tf
Initialize and Apply:

bash
Copy
terraform init
terraform apply -auto-approve
This will provision the rest of your infrastructure (EC2 instances, ALB, Auto Scaling Group, etc.) that rely on the VPC.


2. Ansible Configuration
Dynamic Inventory:
Use the aws_ec2.yaml file for dynamic inventory. Ensure that Web Server 3 and 4 are tagged with ConfigureViaAnsible=Yes.

Run the Playbook:
To configure Web Servers 3 and 4 (installing Apache, configuring the index page, etc.), run:

bash
Copy
ansible-playbook -i aws_ec2.yaml configure_webservers.yml
3. GitHub Actions Workflow
The CI/CD pipeline is configured via .github/workflows/terraform.yml.
This workflow performs:

Terraform formatting, initialization, validation, and plan.

TFLint and Trivy security scans.

Trigger:
It runs on pushes and pull requests to the main branch.

Cleanup Process
Step 1: Destroy Resources from the Root Module
Since the resources in the root module (EC2, ALB, etc.) depend on the VPC, you must destroy them first:

From the Root Module Directory:

bash
Copy
terraform destroy -auto-approve
This removes resources like EC2 instances, ALB, Target Group Attachments, and Auto Scaling Groups.

Step 2: Destroy VPC Module Resources
Once the dependent resources are removed, destroy the VPC resources:

Navigate to the VPC Module Directory:

bash
Copy
cd modules/vpc
Destroy the VPC Resources:

bash
Copy
terraform destroy -auto-approve
Additional Notes
Remote State: Terraform uses an S3 bucket to store state files. Ensure this bucket exists and is correctly configured.

Website Image: Upload the website image to the designated S3 bucket manually.

Sensitive Files: Private key files and Terraform state files are excluded via .gitignore.

GitHub Actions: The workflow leverages AWS credentials stored as GitHub repository secrets (or uses OIDC if configured).

Conclusion
This repository provides a modular, automated approach to deploying a two-tier web application.

Terraform provisions infrastructure (VPC, EC2, ALB, Auto Scaling, etc.).

Ansible configures the web servers (Web Server 3 and 4) to serve the website.

GitHub Actions automates validation, security scans, and CI/CD processes.

Follow the above steps for successful deployment and cleanup of your solution.

