variable "alb_sg_id" {
  type        = string
  description = "ALB security group id"
}

variable "port" {
  type        = number
  description = "Target Group port"
}
variable "http_port" {
  type        = number
  description = "HTTP port"
  default = 80
}
variable "https_port" {
  type        = number
  description = "HTTPS port"
  default = 443
}

variable "protocol" {
  type        = string
  description = "Target Group protocol"
}

variable "vpc_id" {
  type        = string
  description = "Main VPC id"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs for ALB"
}

variable "route53_zone_id" {
  type        = string
  description = "Route53 Hosted Zone ID for the domain"
}

variable "sub_domain" {
  type        = string
  description = "Subdomain for the ALB (e.g., 'app' for app.example.com)" 
}

variable "app_prefix" {
  description = "Application prefix"
  type        = string
}