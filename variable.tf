variable "aws_region" {
  description = "AWS region to deploy the resources"
  default     = "us-east-1"
}

variable "elasticsearch_version" {
  description = "Elasticsearch version to use"
  default     = "7.10"
}
