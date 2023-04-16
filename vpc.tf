module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "cyderes-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Terraform = "true"
    Module    = "vpc"
  })

  public_subnet_tags = merge(var.tags, {
    Tier = "public"
  })

  private_subnet_tags = merge(var.tags, {
    Tier = "private"
  })
}

data "aws_availability_zones" "available" {
  state = "available"
}
