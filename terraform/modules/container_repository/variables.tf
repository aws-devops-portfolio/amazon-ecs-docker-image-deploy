variable "ecr_name" {
  description = "ECR repository name"
  type        = string
  default     = "product-app-ecr"
}

variable "app_prefix" {
  description = "Application prefix"
  type        = string
}