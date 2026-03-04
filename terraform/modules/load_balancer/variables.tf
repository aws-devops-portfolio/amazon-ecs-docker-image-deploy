variable "alb_sg_id" {
    type        = string
    description = "ALB security group id"
}

variable "port" {
    type        = number
    description = "Target Group port"
}

variable "protocol" {
    type        = string
    description = "Target Group protocol"
  
}

variable "vpc_id" {
    type = string
    description = "Main VPC id"
}

variable "subnets" {
    type = list(string)
    description = "List of subnet IDs for ALB"
}