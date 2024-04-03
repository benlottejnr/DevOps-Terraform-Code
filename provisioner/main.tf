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

# Generated the secure key and encrypted to PEM format
resource "tls_private_key" "my_ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
# Create aws key pair component in aws
resource "aws_key_pair" "ec2_key" {
  key_name   = "week12key"
  public_key = tls_private_key.my_ec2_key.public_key_openssh
}
# Save my key pair file to current working directory
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.ec2_key.key_name}.pem"
  content  = tls_private_key.my_ec2_key.private_key_pem
}

resource "aws_instance" "demo1" {
  ami           = "ami-033a1ebf088e56e81"
  instance_type = "t2.micro"
  key_name      = "week12key"
  #subnet_id = "subnet-05db623061fc18aad"
  depends_on    = [aws_key_pair.ec2_key]
}

resource "null_resource" "n1" {
  depends_on = [aws_instance.demo1, local_file.ssh_key]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(local_file.ssh_key.filename)
    host        = aws_instance.demo1.public_ip
  }
  provisioner "local-exec" {
    command = "echo hello >> test.txt"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo useradd benlottejnr",
      "mkdir terraform"
    ]
  }
  provisioner "file" {
    source      = "week12key.pem"
    destination = "/tmp/week12key.pem"
  }
}
