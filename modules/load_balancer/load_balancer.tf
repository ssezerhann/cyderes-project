resource "aws_alb" "this" {
  name            = "cyderes-alb"
  internal        = false
  security_groups = [aws_security_group.this.id]
  subnets         = var.subnet_ids

  tags = {
    Name = "cyderes-alb"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = var.target_group_arn
    type             = "forward"
  }
}
