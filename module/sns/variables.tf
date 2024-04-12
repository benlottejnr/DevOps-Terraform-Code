variable "aws_region" {
  description = "The AWS region where the AWS provider will be configured."
  type        = string
  default     = "us-east-1"
}

variable "sns_topic_name" {
  description = "The name of the SNS topic to be created."
  type        = string
  default     = "example-topic"
}

variable "email_subscription_endpoint" {
  description = "The email address to which SNS notifications will be sent."
  type        = string
  default     = "example@example.com"
}
