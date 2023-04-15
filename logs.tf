resource "aws_cloudwatch_log_group" "alb_access_logs" {
  name              = "${var.project_name}-alb-access-logs"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_subscription_filter" "alb_to_es" {
  name            = "${var.project_name}-alb-to-es"
  log_group_name  = aws_cloudwatch_log_group.alb_access_logs.name
  filter_pattern  = ""
  destination_arn = aws_elasticsearch_domain.main.arn

  depends_on = [aws_cloudwatch_log_group.alb_access_logs]
}

resource "aws_lb" "main" {

  access_logs {
    bucket  = aws_s3_bucket.logs.bucket
    prefix  = "alb"
    enabled = true
  }

}

resource "aws_s3_bucket" "logs" {
  bucket = "${var.project_name}-logs"
  acl    = "log-delivery-write"
}

output "cloudwatch_log_group_alb_access_logs" {
  value = aws_cloudwatch_log_group.alb_access_logs.name
}
