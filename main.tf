module "vpc" {
  source = "./modules/vpc"
}

module "elasticsearch" {
  source = "./modules/elasticsearch"
  vpc_id = module.vpc.vpc_id
  security_group_id = module.vpc.elasticsearch_security_group_id
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs" {
  source = "./modules/ecs"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  ecr_repository_url = module.ecr.repository_url
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  ecs_security_group_id = module.vpc.ecs_security_group_id
  ecs_service_name = module.ecs.service_name
  ecs_task_family = module.ecs.task_family
}

module "logs" {
  source = "./modules/logs"
  elasticsearch_domain_arn = module.elasticsearch.domain_arn
  elasticsearch_domain_endpoint = module.elasticsearch.domain_endpoint
  log_group_name = module.ecs.log_group_name
}

module "security" {
  source = "./modules/security"
  alb_security_group_id = module.vpc.alb_security_group_id
  alb_arn = module.alb.alb_arn
  alb_listener_arn = module.alb.alb_listener_arn
}

module "ebs" {
  source = "./modules/ebs"
  ecs_instance_role = module.ecs.instance_role
}
