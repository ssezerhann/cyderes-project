output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "elasticsearch_domain_endpoint" {
  description = "The endpoint of the Elasticsearch domain"
  value       = module.elasticsearch.domain_endpoint
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_listener_arn" {
  description = "The ARN of the ALB listener"
  value       = module.alb.alb_listener_arn
}

output "log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = module.logs.log_group_name
}
