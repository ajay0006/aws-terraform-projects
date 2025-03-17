# this is a variable that consists of 4 subnets, compromised of 2 public and private subnets each
variable "subnet_configs" {
    default = {
       "Public-1A" = {
        availability_zone = "us-east-1a"
        cidr_block = "10.0.1.0/24"
        map_public_ip_on_launch = true
        Name = "Public-1A"
       },
        "Public-1B" = {
        availability_zone = "us-east-1b"
        cidr_block = "10.0.2.0/24"
        map_public_ip_on_launch = true
        Name = "Public-1B"
       },
       "Private-1A" = {
        availability_zone = "us-east-1a"
        cidr_block = "10.0.3.0/24"
        map_public_ip_on_launch = false
        Name = "Private-1A"
       },
       "Private-1B" = {
        availability_zone = "us-east-1b"
        cidr_block = "10.0.4.0/24"
        map_public_ip_on_launch = false
        Name = "Private-1B"
        }  
    }  
}

resource "aws_vpc" "MyVPC" { # this creates a VPC with the following private ip address range
    cidr_block = "10.0.0.0/16"  
    tags = {
        "Name" = "MyVPC"
    }  
  
}
# this creates the subnets using a for each loop to go tru the subnets_config variable
resource "aws_subnet" "subnets" {
    for_each = var.subnet_configs 
    vpc_id = aws_vpc.MyVPC.id
    availability_zone = each.value.availability_zone
    cidr_block = each.value.cidr_block
    map_public_ip_on_launch = each.value.map_public_ip_on_launch
    tags = {
        Name = each.value.Name
    }  
  
}

# creates a route table that will be used by the private subnets
resource "aws_route_table" "Private-RT" {
    vpc_id = aws_vpc.MyVPC.id
    tags = {
      Name = "Private-RT"
    }  
}

resource "aws_internet_gateway" "MyIGW" { # creates an internet gateway to be used by the public subnets
    vpc_id = aws_vpc.MyVPC.id
    tags = {
      Name = "MyIGW"
    }  
}

# Retrieve the main route table which by default should be the default public one
data "aws_route_table" "main" {
  vpc_id = aws_vpc.MyVPC.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

resource "aws_route" "routeIGW" { # create a route entry in the public/main route table for outbound comms & connect it to the gateway
    route_table_id = data.aws_route_table.main.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyIGW.id
  
}

# associates the private subnets with the route table using a for each loop
resource "aws_route_table_association" "private_subnet_associations" {
    for_each = {
        for k, v in aws_subnet.subnets : k => v 
        if can(regex("Private", k))
    }
    route_table_id = aws_route_table.Private-RT.id
    subnet_id = each.value.id
  }

data "aws_vpc" "existing_vpc" {
    id = aws_vpc.MyVPC.id  
}

data "aws_subnets" "public" { # list the subnets that have the keyword public appended to its name
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.existing_vpc.id]
    }
    filter {
        name = "tag:Name"
        values = ["*Public*"]
    }
}


resource "aws_security_group" "WebAcessMyVPC" { # a security grp that will allow ssh connect to in ec2 instance that is located in the VPC
  name        = "WebAcessMyVPC"
  description = "Allow inbound SSH traffic for VPC"
  vpc_id      = aws_vpc.MyVPC.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebAcessMyVPC"
  }
}

resource "random_integer" "subnet_index" {
    min = 0
    max = length(data.aws_subnets.public.ids)
  
}

resource "aws_instance" "ec2demo2" {
    ami = "ami-04aa00acb1165b32a"
    instance_type = "t2.micro"
    subnet_id = element(tolist(data.aws_subnets.public.ids), random_integer.subnet_index.result)
    vpc_security_group_ids = [aws_security_group.WebAcessMyVPC.id]
    user_data = file("${path.module}/app1-install.sh")
    metadata_options {
      http_endpoint = "enabled"
      http_tokens = "required"
  }
    tags = {
        "Name" = "ec2demo2"
    }
}


