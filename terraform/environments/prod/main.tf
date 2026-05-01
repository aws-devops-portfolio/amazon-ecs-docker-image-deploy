data "aws_route53_zone" "main" {
  name = "mike71techsolutions.com"
}

locals {
  env_app_prefix = "${var.environment}-${var.container_name}"
  modukes_path = "../../modules"
}

module "network" {
  source     = "../../modules/network"
  vpc_cidr   = var.vpc_cidr
  vpce_sg_id = module.security_groups.vpce_sg_id
  app_prefix = local.env_app_prefix
}

module "iam" {
  source     = "../../modules/iam"
  app_prefix = local.env_app_prefix
}

module "container_repository" {
  source     = "../../modules/container_repository"
  app_prefix = local.env_app_prefix
}

module "container_services" {
  source             = "../../modules/container_services"
  target_group_arn   = module.load_balancer.target_group_arn
  task_role_arn      = module.iam.task_role_arn
  private_subnets    = module.network.private_subnet_ids
  region             = var.region
  ecs_task_sg_id     = module.security_groups.ecs_task_sg_id
  execution_role_arn = module.iam.execution_role_arn
  app_prefix         = local.env_app_prefix
  environment        = var.environment
  container_port     = var.container_port
  container_memory   = var.container_memory
  desired_task_count = var.desired_task_count
  maximum_task_count = var.maximum_task_count
  ecr_repo_url       = module.container_repository.ecr_repo_url

  depends_on = [module.network]

}

module "security_groups" {
  source         = "../../modules/security_groups"
  vpc_id         = module.network.vpc_id
  container_port = var.container_port
  app_prefix     = local.env_app_prefix
}

module "load_balancer" {
  source            = "../../modules/load_balancer"
  vpc_id            = module.network.vpc_id
  subnets           = module.network.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  port              = var.container_port
  protocol          = "HTTP"
  sub_domain        = "${var.sub_domain_name}.mike71techsolutions.com"
  route53_zone_id   = data.aws_route53_zone.main.zone_id  
  app_prefix        = local.env_app_prefix
}

# Sub domain record
resource "aws_route53_record" "sub_domain" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.sub_domain_name
  type    = "A"

  alias {
    name                   = module.load_balancer.alb_dns_name
    zone_id                = module.load_balancer.alb_zone_id
    evaluate_target_health = true
  }
}