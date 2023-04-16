resource "aws_ecs_cluster" "cyderes_ecs_cluster" {
  name = "cyderes-ecs-cluster"
  tags = merge(var.tags, {
    Name = "cyderes-ecs-cluster"
  })
}

resource "aws_ecs_task_definition" "cyderes_ecs_task_definition" {
  family                   = "cyderes-ecs-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.cyderes_ecs_execution_role.arn
  task_role_arn            = aws_iam_role.cyderes_ecs_task_role.arn

  container_definitions = jsonencode([{
    name      = "webserver"
    image     = data.aws_ecr_image.cyderes_ecr_image.repository_url
    essential = true
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
    }]
  }])

  tags = merge(var.tags, {
    Name = "cyderes-ecs-task-definition"
  })
}

resource "aws_ecs_service" "cyderes_ecs_service" {
  name            = "cyderes-ecs-service"
  cluster         = aws_ecs_cluster.cyderes_ecs_cluster.id
  task_definition = aws_ecs_task_definition.cyderes_ecs_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.cyderes_ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arn
    container_name   = "webserver"
    container_port   = var.container_port
  }

  depends_on = [module.alb]

  tags = merge(var.tags, {
    Name = "cyderes-ecs-service"
  })
}

resource "aws_iam_role" "cyderes_ecs_execution_role" {
  name = "cyderes-ecs-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "cyderes_ecs_task_role" {
  name = "cyderes-ecs-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}
