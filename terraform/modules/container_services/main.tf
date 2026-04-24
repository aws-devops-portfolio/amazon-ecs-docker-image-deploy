
# ECS  cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.cluster_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Task definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "task-definition-${var.container_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn  

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = "889049355474.dkr.ecr.us-east-1.amazonaws.com/product-app-ecr:latest"

      cpu    = var.container_cpu
      memory = var.container_memory

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/task-definition-${var.container_name}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "product_ecs_logs" {
  name              = "/ecs/task-definition-${var.container_name}"
  retention_in_days = 30
}

# ECS service
resource "aws_ecs_service" "service" {
  name            = "${var.container_name}-service"
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
  max_capacity       = 4
  min_capacity       = 2
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
