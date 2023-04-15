resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.project_name}-vpc"
  }
}


resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "Ingress rule to restrict traffic from 10.0.0.0/8"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Egress rule to allow all traffic"
  }

  tags = {
    Name = "${var.project_name}-default-sg"
  }
}

resource "aws_s3_bucket" "flow_logs" {
  bucket = "${var.project_name}-flow-logs"
  acl    = "log-delivery-write"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  public_access_block_configuration {
    block_public_acls   = true
    block_public_policy = true
    ignore_public_acls  = true
    restrict_public_buckets = true
  }

  logging {
    target_bucket = var.target_bucket
    target_prefix = "log/${var.s3_bucket_name}"
  }
}

resource "aws_s3_bucket_public_access_block" "flow_log_access" {
  bucket = aws_s3_bucket.flow_logs.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

resource "aws_flow_log" "flow_log" {
  iam_role_arn        = aws_iam_role.example.arn
  log_destination      = aws_s3_bucket.flow_logs.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id
}
