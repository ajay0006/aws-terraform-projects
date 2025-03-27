resource "aws_security_group" "vpc-ssh" { # a security grp that will allow ssh connect to in ec2 instance that is located in the VPC
  name        = "VPC-SSH"
  description = "Allow inbound SSH traffic for VPC"
  # if i do not mention a vpc id, it creates this SG in the default vpc
#   vpc_id      = aws_vpc.defaultVPC.id

  ingress {
    description = "SSH from 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all IP and ports communication going outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-ssh"
  }
}