
data "aws_caller_identity" "current" {}

locals {
  ecr_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repo_name}"  
}

# ECS  cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Task definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "task-definition-${var.app_prefix}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn  

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = "${local.ecr_url}:latest"

      cpu    = var.container_cpu
      memory = var.container_memory

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]

      environment = [
        {
          name  = "SPRING_PROFILES_ACTIVE"
          value = var.environment
        },
        {
          name  = "SERVER_PORT"
          value = tostring(var.container_port)
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/task-definition-${var.app_prefix}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "product_ecs_logs" {
  name              = "/ecs/task-definition-${var.app_prefix}"
  retention_in_days = 30
}

# ECS service
resource "aws_ecs_service" "service" {
  name            = "${var.app_prefix}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.ecs_task_sg_id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [aws_cloudwatch_log_group.product_ecs_logs]

}

resource "aws_appautoscaling_target" "ecs_scaling_target" {
  max_capacity       = var.maximum_task_count
  min_capacity       = var.desired_task_count
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu" {
  name               = "cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 50.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
