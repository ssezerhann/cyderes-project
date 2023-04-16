variable "region" {
  type = string
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  type = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "elasticsearch_instance_type" {
  type = string
  default = "t2.small.elasticsearch"
}

variable "web_server_instance_type" {
  type = string
  default = "t2.micro"
}

variable "web_server_container_image" {
  type = string
  default = "nginx:latest"
}

variable "log_retention_days" {
  type = number
  default = 30
}
