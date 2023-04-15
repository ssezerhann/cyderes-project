resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "webserver" {
  family                = "${var.project_name}-webserver"
  container_definitions = jsonencode([{
    name  = var.container_name
    image = var.container_image
    essential = true
    memoryReservation = 256
    portMappings = [
      {
        containerPort = var.container_port
        hostPort      = 0
        protocol      = "tcp"
      }
    ],
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.webserver.name
        "awslogs-region"        = data.aws_region.current.name
        "awslogs-stream-prefix" = "webserver"
      }
    }
  }])

  volume {
    name      = "webserver-storage"
    host_path = "/ecs/webserver-storage"
  }

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
}

resource "aws_ecs_service" "webserver" {
  name            = "${var.project_name}-webserver"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.webserver.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.main]
}

resource "aws_cloudwatch_log_group" "webserver" {
  name              = "${var.project_name}-webserver-logs"
  retention_in_days = 14
}

data "aws_region" "current" {}
