variable "region" {
  description = "Region name"
  type = string
}
variable "task_role_arn" {
  description = "Task Role ARN"
  type = string
}
variable "execution_role_arn" {
  description = "Execution Role ARN"
  type = string
}
variable "cluster_name" {
  description = "ECS Cluster name"
  type = string
  default = "product-app"
}
variable "ecr_repo_name" {
  description = "ECR repository name"
  type = string
  default = "product-app"
}
variable "container_name" {
  description = "Container name"
  type = string
  default = "product-app"
}
variable "container_port" {
  description = "Container port"
  type = number
  default = 8080
}
variable "host_port" {
  description = "Host port"
  type = number
  default = 8080
}
variable "container_cpu" {
  description = "Container CPU"
  type = number
  default = 256
}
variable "container_memory" {
  description = "Container memory"
  type = number
  default = 512
}
variable "task_count" {
  description = "Number of ECS tasks"
  type = number
}
variable "target_group_id" {
  description = "Target Group Id"
  type = string
}
variable "ecs_sg_id" {
  description = "ECS Security Group Id"
  type = string
}
variable "private_subnets" {
  description = "List of Private subnets"
  type = list(string)
}
