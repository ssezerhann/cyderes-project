output "elasticsearch_endpoint" {
  value = module.elasticsearch.endpoint
}

output "s3_bucket_name" {
  value = module.s3_bucket.bucket_name
}

output "web_server_target_group_arn" {
  value = module.web_server.target_group_arn
}
