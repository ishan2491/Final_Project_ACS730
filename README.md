# Final Project: Two-Tier Web Application Automation
This repository contains the code for provisioning and configuring a two-tier web application. The project leverages Terraform for infrastructure provisioning, Ansible for configuration management, and GitHub Actions for automated CI/CD processes and security scans.
---
## Table of Contents
- [Overview](#overview)
- [Pre-requisites](#pre-requisites)
- [Remote Terraform State (S3 Bucket)](#remote-terraform-state-s3-bucket)
- [Website Images Bucket](#website-images-bucket)
- [SSH Key Pairs](#ssh-key-pairs)
- [AWS Credentials for CI/CD](#aws-credentials-for-cicd)
- [Deployment Process](#deployment-process)
  - [Deploy VPC Module](#deploy-vpc-module)
  - [Deploy the Root Module](#deploy-the-root-module)
- [Ansible Configuration](#ansible-configuration)
  - [Dynamic Inventory](#dynamic-inventory)
  - [Playbook for Configuring Web Servers](#playbook-for-configuring-web-servers)
  - [Running the Playbook](#running-the-playbook)
- [GitHub Actions Workflow](#github-actions-workflow)
- [Cleanup Process](#cleanup-process)
  - [Destroy Root Module Resources](#destroy-root-module-resources)
  - [Destroy VPC Module Resources](#destroy-vpc-module-resources)
- [Additional Notes](#additional-notes)
- [Recording Instructions](#recording-instructions)
- [Conclusion](#conclusion)
---
## Overview
This project automates the deployment of a two-tier web application by combining:
- **Terraform:** Infrastructure as Code to create and manage AWS resources (VPC, EC2 instances, ALB, Auto Scaling, etc.).
- **Ansible:** Configuration management to set up and maintain web servers.
- **GitHub Actions:** CI/CD pipeline automation including Terraform formatting, initialization, validation, planning, and security scans using tools like TFLint and Trivy.
---
## Pre-requisites
Before you begin, ensure you have:
- An **AWS Account** with necessary permissions (create/manage S3 buckets, EC2, ALB, IAM roles, etc.).  
  *If using a college-provided account, verify permissions with your administrator.*
---
## Remote Terraform State (S3 Bucket)
Terraform state files are securely stored in an S3 bucket.
### Action
Create an S3 bucket using the AWS CLI:
```bash
aws s3 mb s3://final-project-acs730-yourname --region us-east-1
```

## Configuration

In your root module's main.tf, configure the backend as follows:

```hcl
terraform {
  backend "s3" {
    bucket  = "final-project-acs730-yourname"
    key     = "two-tier-app/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
```

## Website Images Bucket

An S3 bucket is used to store website images. Ensure that this bucket is not public.

### Action

Create the S3 bucket with:

```bash
aws s3 mb s3://your-website-images-bucket --region us-east-1
```

**Note:** Manually upload your website images using the AWS Console or CLI.

## SSH Key Pairs

Generate SSH key pairs to securely access your EC2 instances. Do not commit private keys to your repository.

Example:

```bash
ssh-keygen -t rsa -b 2048 -f bastion_key.pem
ssh-keygen -t rsa -b 2048 -f web_key.pem
```

The public keys (bastion_key.pem.pub and web_key.pem.pub) should be referenced in your Terraform code. Remember to add private key files (e.g., .pem files) to your .gitignore.

## AWS Credentials for CI/CD

For GitHub Actions, store your AWS credentials as repository secrets:

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN (if using temporary credentials)

Workflow Configuration Example:

```yaml
- name: Configure AWS credentials using static secrets
  uses: aws-actions/configure-aws-credentials@v2
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-session-token: ${{ secrets.AWS_SESSION_TOKEN }}
    aws-region: us-east-1
```

## Deployment Process

### Deploy VPC Module

Navigate to the VPC module directory:

```bash
cd modules/vpc
```

Initialize Terraform and apply the configuration:

```bash
terraform init
terraform apply -auto-approve
```

This step creates your VPC, subnets, NAT gateway, and related networking components. The outputs (such as vpc_id, public_subnets, private_subnets) are stored in the S3 backend for later reference by the root module.

### Deploy the Root Module

Return to the root directory:

```bash
cd ../..
```

Initialize and apply Terraform:

```bash
terraform init
terraform apply -auto-approve
```

This provisions the remainder of your infrastructure including EC2 instances, ALB, and Auto Scaling Group that utilize the remote state outputs from the VPC module.

## Ansible Configuration

### Dynamic Inventory

Configure the aws_ec2.yaml file for dynamic inventory to target only instances tagged with ConfigureViaAnsible=Yes. This tag should be applied to Web Server 3 and Web Server 4 in the Terraform configuration.

Example aws_ec2.yaml:

```yaml
plugin: aws_ec2
regions:
  - us-east-1
filters:
  instance-state-name: running
  tag:ConfigureViaAnsible: "Yes"
keyed_groups:
  - key: tags.ConfigureViaAnsible
    prefix: configure
```

### Playbook for Configuring Web Servers

Create a playbook file named configure_webservers.yml to set up the web servers:

```yaml
---
- name: Configure Web Servers (Web Server 3 and 4)
  hosts: configure_Yes
  become: yes
  tasks:
    - name: Install Apache HTTP Server
      yum:
        name: httpd
        state: present

    - name: