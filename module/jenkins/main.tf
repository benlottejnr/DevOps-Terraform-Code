provider "aws" {
  region = var.region
}

# Configure Terraform backend with S3 and DynamoDB
terraform {
  backend "s3" {
    bucket         = "20240411-bentest"
    key            = "LockID"
    region         = "us-east-1"
    dynamodb_table = "jenkins-terraform-table"
  }
}

# Generated the secure key and encrypted to PEM format
resource "tls_private_key" "my_ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
# Create aws key pair component in aws
resource "aws_key_pair" "ec2_key" {
  key_name   = var.key_name
  public_key = tls_private_key.my_ec2_key.public_key_openssh
}
# Save my key pair file to current working directory
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.ec2_key.key_name}.pem"
  content  = tls_private_key.my_ec2_key.private_key_pem
}

# Define security group to allow inbound traffic on port 8080 and SSH (port 22)
resource "aws_security_group" "jenkins_security_group" {
  name        = "jenkins-security-group"
  description = "Security group for Jenkins server"
  
  # Allow traffic on port 8080 (for Jenkins)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH traffic on port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "jenkins_server" {
  ami           = "ami-0a699202e5027c10d" # Specify the AMI ID of your choice
  instance_type = "t2.micro"
  key_name = var.key_name
  tags = {
    Name = "JenkinsServer"
  }

  # Configure security group
  security_groups = [aws_security_group.jenkins_security_group.name]

  # Use user data to install Jenkins
  user_data = <<-EOF
            #!/bin/bash -x
            sudo yum update -y
            sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
            sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
            sudo yum upgrade -y
            ## Install Java 11:
            sudo yum install java-11* -y
            ## Install Jenkins then Enable the Jenkins service to start at boot :
            sudo yum install jenkins -y
            sudo systemctl enable jenkins
            ## Start Jenkins as a service:
            sudo systemctl start jenkins
            EOF
}


