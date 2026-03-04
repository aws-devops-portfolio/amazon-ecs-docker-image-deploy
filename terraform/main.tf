
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["false"]
  }
}

module "iam_fargate" {
  source = "./modules/iam_fargate"

}

module "container_repository" {
  source   = "./modules/container_repository"
  ecr_name = "app_ecr"

}

module "container_services" {
  source             = "./modules/container_services"
  target_group_id    = module.load_balancer.target_group_id
  task_role_arn      = module.iam_fargate.task_role_arn
  private_subnets    = data.aws_subnets.private_subnets.ids
  region             = "us-east-1"
  ecs_sg_id          = module.security_groups.ecs_task_sg
  task_count         = 1
  execution_role_arn = module.iam_fargate.execution_role_arn
  container_port     = 8080
  container_memory   = 512
  ecr_repo_url       = module.container_repository.ecr_repo_url
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = data.aws_vpc.default.id
}

module "load_balancer" {
  source    = "./modules/load_balancer"
  vpc_id    = data.aws_vpc.default.id
  subnets   = data.aws_subnets.default.ids
  alb_sg_id = module.security_groups.alb_sg_id
  port      = 8080
  protocol  = "HTTP"
}