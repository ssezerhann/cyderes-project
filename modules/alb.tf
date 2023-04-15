resource "aws_lb" "main" {
  name                     = "${var.project_name}-alb"
  internal                 = false
  load_balancer_type       = "application"
  security_groups          = [var.alb_security_group_id]
  subnets                  = var.subnet_ids
  enable_deletion_protection = true
  drop_invalid_header_fields = true

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.bucket
    prefix  = "access_logs"
    enabled = true
  }
}

resource "aws_lb_target_group" "main" {
  name     = "${var.project_name}-target-group"
  port     = var.container_port
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.ssl_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_s3_bucket" "alb_logs" {
  bucket = "${var.project_name}-alb-logs"
  acl    = "log-delivery-write"

  versioning {
    status = "Enabled"
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "alb_logs/"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.project_name}-log-bucket"
  acl    = "log-delivery-write"

  versioning {
    status = "Enabled"
  }
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}
