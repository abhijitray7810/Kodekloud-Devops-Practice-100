# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "datacenter_ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  
  tags = {
    Name = "datacenter-ec2"
  }
}

data "aws_sns_topic" "datacenter_sns_topic" {
  name = "datacenter-sns-topic"
}

resource "aws_cloudwatch_metric_alarm" "datacenter_alarm" {
  alarm_name          = "datacenter-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "90"
  alarm_description   = "This alarm triggers when CPU utilization exceeds 90% for 5 minutes"
  alarm_actions       = [data.aws_sns_topic.datacenter_sns_topic.arn]
  
  dimensions = {
    InstanceId = aws_instance.datacenter_ec2.id
  }
}
