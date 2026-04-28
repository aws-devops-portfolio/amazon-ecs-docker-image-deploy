variable "task_service_role" {
  description = "Task Service Role name"
  type        = string
  default     = "AppTaskServiceRole"
}
variable "app_prefix" {
  description = "Application prefix"
  type        = string
}