module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = var.vpc_cidr_block
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}

module "security_group" {
  source = "./modules/security_group"

  vpc_id = module.vpc.vpc_id
}

module "web_server" {
  source = "./modules/web_server"

  subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_group.this_security_group_id
}

module "load_balancer" {
  source = "./modules/load_balancer"

  subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_group.this_security_group_id
  target_group_arn = module.web_server.target_group_arn
}

module "elasticsearch" {
  source = "./modules/elasticsearch"

  subnet_ids = module.vpc.private_subnet_ids
  elasticsearch_instance_type = var.elasticsearch_instance_type
}

module "s3_bucket" {
  source = "./modules/s3_bucket"
}

module "logs" {
  source = "./modules/logs"
}

