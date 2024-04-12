provider "aws" {
  region = var.aws_region
}

# Create an SNS topic
resource "aws_sns_topic" "example_topic" {
  name = var.sns_topic_name
}


#I will setup only email sub' even though there is option for sms & http endpoints
# Define email subscription
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "email"
  endpoint  = var.email_subscription_endpoint
}

/*
# Define SMS subscription
resource "aws_sns_topic_subscription" "sms_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "sms"
  endpoint  = "+1234567890"
}

# Define HTTP subscription (e.g., to notify an endpoint)
resource "aws_sns_topic_subscription" "http_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "http"
  endpoint  = "https://example.com/webhook"
}
*/