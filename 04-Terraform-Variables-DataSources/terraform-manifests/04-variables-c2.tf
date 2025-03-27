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

# AWS EC@ Instance Key Pair
variable "instance_keypair" {
    description = "AWS EC2 key pair that is associated with the created EC2 Instance"
    type = string
    default = "terraform-key"
  
}