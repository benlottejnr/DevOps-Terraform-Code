terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
  }
}
provider "aws" {

  region = "us-east-1"
}
/*
resource "aws_iam_group" "gp1" {
  name = "manager24"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_user" "usr1" {
  name = "ben10"
}
*/

resource "aws_instance" "server1" {
  ami = "ami-033a1ebf088e56e81"
  instance_type = "t2.micro"
  key_name = "wordpress"
  subnet_id = "subnet-029c17da86c077475"
  lifecycle {
    create_before_destroy = true
  }
}