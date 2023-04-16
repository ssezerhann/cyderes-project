# Cyderes Terraform Infrastructure

This Terraform project sets up the following infrastructure on AWS:

1. VPC with public and private subnets
2. Elastic Container Registry (ECR) repository for the web server container image
3. Elastic Container Service (ECS) cluster, task definition, and service for the web server container
4. Application Load Balancer (ALB) to forward traffic to the web server container
5. Security groups for the ALB and ECS service
6. CloudWatch Log Group for the ECS container logs
