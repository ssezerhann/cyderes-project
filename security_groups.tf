resource "aws_security_group" "cyderes_alb_sg" {
  name        = "cyderes-alb-sg"
  description = "Allow inbound traffic to the ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = var.alb_port
    to_port     = var.alb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "cyderes-alb-sg"
  })
}

resource "aws_security_group" "cyderes_ecs_sg" {
  name        = "cyderes-ecs-sg"
  description = "Allow inbound traffic from ALB to ECS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.cyderes_alb_sg.id]
  }

  tags = merge(var.tags, {
    Name = "cyderes-ecs-sg"
  })
}
