# Terraform Settings Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.90" # Optional but recommended in production
    }
  }
}

# Provider Block
provider "aws" {
  profile = "adminTr" # using AWS SSO so the profile name in the config file for aws cli is what will be used
  region  = "us-east-1"
}

# Resource Block
resource "aws_instance" "ec2demo" {
  ami           = "ami-04aa00acb1165b32a" # Amazon Linux in us-east-1, update as per your region
  instance_type = "t2.micro"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }
  tags = {
    Name = "ec2demo" # specifies the name of th ec2 instance 
  }
}