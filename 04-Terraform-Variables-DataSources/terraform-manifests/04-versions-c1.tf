# Terraform  Block
terraform {
  required_version = ">= 1.11.0"
  // required_version = "~>= 1.11.0" allows 1.11.1 - 1.11.10 but deny 1.12 > 
  required_providers {
    aws = {    # this is an argument due to the equal sign, above has no equal sign so it is a block
      source  = "hashicorp/aws"
      version = ">= 5.90"
    }
  }
  # Adding Backend as S3 for Remote State Storage with State Locking, meaniong i am storing the .tfstate files in the s3 bucket
  backend "s3" {
    bucket = "myawsbucket-tf-state-storage"
    key    = "dev2/terraform.tfstate"
    region = var.aws_region
    profile = "adminTr" 

    # For State Locking
    use_lockfile = true
  }
}
# provider block
provider "aws" {
  profile = "adminTr"
  region = var.aws_region
}