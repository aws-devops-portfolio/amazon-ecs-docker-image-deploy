variable "vpc_cidr" {
  type        = string
  description = "CIDR block"  
}

variable "region" {
  type        = string
  description = "AWS region"    
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "container_name" {
  type        = string
  description = "Container name"
}

variable "container_port" {
  type        = number
  description = "Container port" 
}

variable "container_memory" {
  type        = number
  description = "Container memory" 
}

variable "container_cpu" {
  type        = number
  description = "Container CPU units" 
}

variable "desired_task_count" {
  type        = number
  description = "Desired task count" 
}

variable "maximum_task_count" {
  type        = number
  description = "Maximum task count" 
}

variable "route53_hosted_zone" {
  type        = string
  description = "Route53 hosted zone name"   
}

variable "sub_domain_name" {
  type        = string
  description = "Sub domain name" 
}