variable "all_traffic" {
  type        = string
  description = "All traffic CIDR block"
  default     = "0.0.0.0/0"
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

variable "container_port" {
  type        = number
  description = "Container port"  
}

variable "vpc_id" {
  type        = string
  description = "Main VPC id"
}

variable "app_prefix" {
  description = "Application prefix"
  type        = string
}