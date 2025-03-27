#  Input variables

# AWS Region
variable "aws_region" {
    description = "Region in which AWS Resources will be created"
    type = string
    default = "us-east-1"
  
}

# AWS EC2 Instance Type
variable "instance_type" {
    description = "EC2 Instance type"
    type = string
    default = "t3.micro"  
}

# AWS Linuz AMI
variable "ami_type" {
    description = "Amazon Linux 64-bit (x86), uefi-preferred)"
    type = string
    default = "ami-071226ecf16aa7d96"  
}