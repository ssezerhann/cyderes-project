resource "aws_cloudwatch_log_group" "cyderes_ecs_logs" {
  name              = "cyderes-ecs-logs"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.cyderes_logs_kms_key.arn

  tags = merge(var.tags, {
    Name = "cyderes-ecs-logs"
  })
}

resource "aws_kms_key" "cyderes_logs_kms_key" {
  description = "Key for encrypting CloudWatch Logs"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Effect   = "Allow"
        Resource = "*"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "cyderes-logs-kms-key"
  })
}

data "aws_caller_identity" "current" {}
