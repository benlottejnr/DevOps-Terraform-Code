variable "region" {
  default = "us-east-1"
}

variable "key_name" {
  description = "Key name in aws"
  default = "jenkins-key"
  type = string
}