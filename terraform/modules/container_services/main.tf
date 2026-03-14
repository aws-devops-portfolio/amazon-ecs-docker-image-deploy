
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

  depends_on = [aws_cloudwatch_log_group.TaskDF-Log_Group]

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = "${var.ecr_repo_url}:latest"

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

resource "aws_cloudwatch_log_group" "TaskDF-Log_Group" {
  name              = "/ecs/task-definition-${var.container_name}"
  retention_in_days = 30
}

# ECS service
resource "aws_ecs_service" "service" {
  name            = "${var.container_name}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.task_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.ecs_sg_id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_id
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [
    aws_nat_gateway.nat-gw
  ]


}
