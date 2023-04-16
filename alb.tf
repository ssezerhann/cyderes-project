resource "aws_lb" "cyderes_alb" {
  name               = "cyderes-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.cyderes_alb_sg.id]
  subnets            = module.vpc.public_subnets

  tags = merge(var.tags, {
    Name = "cyderes-alb"
  })
  drop_invalid_header_fields = true
  access_logs {
    enabled = true
  }
  enable_deletion_protection = true
}

resource "aws_lb_listener" "cyderes_alb_listener" {
  load_balancer_arn = aws_lb.cyderes_alb.arn
  port              = var.alb_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cyderes_alb_target_group.arn
  }
}

resource "aws_lb_target_group" "cyderes_alb_target_group" {
  name     = "cyderes-alb-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  tags = merge(var.tags, {
    Name = "cyderes-alb-target-group"
  })
}

output "alb_dns_name" {
  value = aws_lb.cyderes_alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.cyderes_alb_target_group.arn
}

