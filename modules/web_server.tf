resource "aws_launch_configuration" "this" {
  image_id = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 LTS
  instance_type = var.web_server_instance_type

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World!" > /var/www/html/index.html
  EOF
}

resource "aws_autoscaling_group" "this" {
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier = var.subnet_ids

  tags = [
    {
      key                 = "Name"
      value               = "cyderes-asg"
      propagate_at_launch = true
    },
  ]
}

resource "aws_alb_target_group" "this" {
  port = 80
  vpc_id = var.vpc_id

  tags = {
    Name = "cyderes-target-group"
  }
}

output "target_group_arn" {
  value = aws_alb_target_group.this.arn
}
