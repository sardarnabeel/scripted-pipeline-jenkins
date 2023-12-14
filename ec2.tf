# ec2.tf

variable "aws_region" {
  description = "AWS Region"
}

variable "ami_id" {
  description = "AMI ID"
}

variable "instance_name" {
  description = "Instance Name Tag"
}

provider "aws" {
  region  = var.aws_region
  profile = "nabeel"  # sso-profile-name
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = var.instance_name
  }
}

output "instance_id" {
  value = aws_instance.example.id
}
