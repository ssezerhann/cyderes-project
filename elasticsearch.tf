resource "aws_elasticsearch_domain" "main" {
  domain_name           = "${var.project_name}-es"
  elasticsearch_version = "7.9"

  cluster_config {
    instance_type = "t2.small.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp3"
    volume_size = 20
  }

  vpc_options {
    security_group_ids = [var.security_group_id]
    subnet_ids         = aws_subnet.private.*.id
  }

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "es:*"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Resource = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${aws_elasticsearch_domain.main.domain_name}/*"
        Condition = {
          IpAddress = {
            "aws:SourceIp" = aws_vpc.main.cidr_block
          }
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-elasticsearch"
  }
  log_publishing_options {
    cloudwatch_log_group_arn = "CKV_ANY"
  }
}


data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
