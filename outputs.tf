output "elasticsearch_endpoint" {
  description = "Elasticsearch domain endpoint"
  value       = module.elasticsearch.endpoint
}


output "elasticsearch_kibana_endpoint" {
  description = "The Kibana endpoint of the Elasticsearch domain"
  value       = module.elasticsearch.kibana_endpoint
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_id
}
