resource "aws_vpc" "MyVpc" { # this creates a VPC with the following private ip address range
    cidr_block = "10.1.0.0/16"
  
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