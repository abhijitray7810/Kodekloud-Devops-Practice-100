provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table with minimal configuration
resource "aws_dynamodb_table" "datacenter_table" {
  name           = var.KKE_TABLE_NAME
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = var.KKE_TABLE_NAME
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Create IAM role that can be assumed by trusted AWS services
resource "aws_iam_role" "datacenter_role" {
  name = var.KKE_ROLE_NAME

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com",
            "ec2.amazonaws.com",
            "ecs-tasks.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = var.KKE_ROLE_NAME
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Create IAM policy for read-only access to the specific DynamoDB table
resource "aws_iam_policy" "datacenter_readonly_policy" {
  name        = var.KKE_POLICY_NAME
  description = "Read-only access to the ${var.KKE_TABLE_NAME} DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = aws_dynamodb_table.datacenter_table.arn
      }
    ]
  })

  tags = {
    Name        = var.KKE_POLICY_NAME
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "datacenter_policy_attachment" {
  role       = aws_iam_role.datacenter_role.name
  policy_arn = aws_iam_policy.datacenter_readonly_policy.arn
}
