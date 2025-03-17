resource "aws_vpc" "MyVpc" { # this creates a VPC with the following private ip address range
    cidr_block = "10.0.0.0/16"  
}

resource "aws_subnet" "Public-1A" {
    vpc_id = aws_vpc.Public-1A
    availability_zone = "us-east-1a"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
  
}

resource "aws_subnet" "Public-1B" {
    vpc_id = aws_vpc.Public-1B
    availability_zone = "us-east-1b"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
  
}

resource "aws_subnet" "Private-1A" {
    vpc_id = aws_vpc.Private-1A
    availability_zone = "us-east-1a"
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = false
  
}

resource "aws_subnet" "Private-1B" {
    vpc_id = aws_vpc.Private-1A
    availability_zone = "us-east-1b"
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = false
  
}

resource "aws_instance" "ec2demo2" {
    ami = "ami-04aa00acb1165b32a"
    instance_type = "t2.micro"
    user_data = file("${path.module}/app1-install.sh")
    metadata_options {
      http_endpoint = "enabled"
      http_tokens = "required"
  }
    tags = {
        "Name" = "ec2demo2"
    }  
}