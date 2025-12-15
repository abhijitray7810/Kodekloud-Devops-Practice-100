resource "aws_iam_policy" "iampolicy_mariyam" {
  name        = "iampolicy_mariyam"
  description = "Read-only access to EC2 console - allows viewing instances, AMIs, and snapshots"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:GetConsole*",
          "ec2:GetPasswordData",
          "ec2:GetSerialConsoleAccessStatus",
          "ec2:SearchTransitGatewayRoutes"
        ]
        Resource = "*"
      }
    ]
  })
}

output "policy_arn" {
  description = "ARN of the created IAM policy"
  value       = aws_iam_policy.iampolicy_mariyam.arn
}

output "policy_name" {
  description = "Name of the created IAM policy"
  value       = aws_iam_policy.iampolicy_mariyam.name
}
