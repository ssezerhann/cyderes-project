provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

module "elasticsearch" {
  source = "lgallard/elasticsearch/aws"
  version = "0.3.1"

  domain_name           = "my-elasticsearch"
  elasticsearch_version = "7.10"
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_subnet_ids
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "allow_http" {
  security_group_id = aws_security_group.allow_http.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name = "my-eks"
  subnets      = module.vpc.private_subnet_ids
  tags = {
    Terraform = "true"
    Kubernetes = "EKS"
  }

  vpc_id = module.vpc.vpc_id
}

locals {
  kubeconfig = yamldecode(aws_eks_cluster.this.kubeconfig)
}
