variable "AZ-Zones" {
    default = {
       "AZ1" = {
        availability_zone = "us-east-1a"
        Name = "AZ1"
       },
        "AZ2" = {
        availability_zone = "us-east-1b"
        Name = "AZ2"
       } 
    }  
}

resource "aws_instance" "ec2EBS" {
    for_each = var.AZ-Zones
    ami = var.ami_type
    instance_type = var.instance_type
    availability_zone = each.value.availability_zone
    # subnet_id = element(tolist(data.aws_subnets.public.ids), random_integer.subnet_index.result)
    # vpc_security_group_ids = [aws_security_group.WebAcessMyVPC.id]
    user_data = file("${path.module}/app1-install.sh")
    metadata_options {
      http_endpoint = "enabled"
      http_tokens = "required"
  }
    tags = {
        "Name" = "ec2EBS"+ "-" + each.value.name
    }
}