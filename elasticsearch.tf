resource "aws_elasticsearch_domain" "cyderes_elasticsearch" {
  domain_name           = "cyderes-elasticsearch"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t2.small.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp3"
    volume_size = 10
  }

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "es:*"
        Effect   = "Allow"
        Resource = "${aws_elasticsearch_domain.cyderes_elasticsearch.arn}/*"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })

  vpc_options {
    security_group_ids = [aws_security_group.cyderes_elasticsearch_sg.id]
    subnet_ids         = module.vpc.private_subnets
  }

  tags = merge(var.tags, {
    Name = "cyderes-elasticsearch"
  })
}

output "elasticsearch_endpoint" {
  value = aws_elasticsearch_domain.cyderes_elasticsearch.endpoint
}
