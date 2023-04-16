resource "aws_cloudwatch_log_group" "this" {
  name = "cyderes-log-group"

  tags = {
    Name = "cyderes-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "web_server" {
  name           = "cyderes-web-server-log-stream"
  log_group_name = aws_cloudwatch_log_group.this.name

  tags = {
    Name = "cyderes-web-server-log-stream"
  }
}

resource "aws_cloudwatch_log_stream" "load_balancer" {
  name           = "cyderes-load-balancer-log-stream"
  log_group_name = aws_cloudwatch_log_group.this.name

  tags = {
    Name = "cyderes-load-balancer-log-stream"
  }
}
