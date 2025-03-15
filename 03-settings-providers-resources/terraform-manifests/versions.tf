# Terraform  Block
terraform {
  required_version = ">= 1.11.0"
  // required_version = "~>= 1.11.0" allows 1.11.1 - 1.11.10 but deny 1.12 > 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.90"
    }
  }
  # Adding Backend as S3 for Remote State Storage with State Locking
  backend "s3" {
    bucket = "terraform-tf-files"
    key    = "dev2/terraform.tfstate"
    region = "us-east-1"  

    # For State Locking
    dynamodb_table = "terraform-dev-state-table"
  }
}