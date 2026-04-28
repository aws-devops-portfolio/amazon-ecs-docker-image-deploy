variable "region" {
  description = "Region name"
  type        = string
}
variable "task_role_arn" {
  description = "Task Role ARN"
  type        = string
}
variable "execution_role_arn" {
  description = "Execution Role ARN"
  type        = string
}
variable "ecr_repo_name" {
  description = "ECR repository name"
  type        = string
  default     = "product-app-ecr"
}
variable "ecr_repo_url" {
  description = "ECR repository URL"
  type        = string
}
variable "app_prefix" {
  description = "Application prefix"
  type        = string
}
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "container_name" {
  description = "Container name"
  type        = string
  default     = "product-app"
}
variable "container_port" {
  description = "Container port"
  type        = number
  default     = 8080
}
variable "container_cpu" {
  description = "Container CPU"
  type        = number
  default     = 256
}
variable "container_memory" {
  description = "Container memory"
  type        = number
  default     = 512
}
variable "desired_task_count" {
  description = "Desired number of ECS tasks"
  type        = number
}
variable "maximum_task_count" {
  description = "Maximum number of ECS tasks"
  type        = number
}
variable "target_group_arn" {
  description = "Target Group ARN"
  type        = string
}
variable "ecs_task_sg_id" {
  description = "ECS Security Group Id"
  type        = string
}
variable "private_subnets" {
  description = "List of Private subnets"
  type        = list(string)
}
