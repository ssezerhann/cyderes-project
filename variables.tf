variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "elasticsearch_version" {
  default = "7.10"
}

variable "instance_type" {
  default = "t2.small.elasticsearch"
}

variable "volume_type" {
  default = "gp3"
}

variable "webserver_container_image" {
  default = "nginx:latest"
}

variable "container_port" {
  default = 80
}

variable "alb_port" {
  default = 80
}
