variable "aws_region" {
  description = "The AWS region to deploy resources in"
  default     = "us-west-2"
}

variable "project_name" {
  description = "The name of the project"
  default     = "cyderes-project"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "The private subnets for the VPC"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "The public subnets for the VPC"
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "container_name" {
  description = "The name of the container to be deployed"
  default     = "webserver"
}

variable "container_image" {
  description = "The image to use for the container"
  default     = "nginx:latest"
}

variable "container_port" {
  description = "The port that the container listens on"
  default     = 80
}
