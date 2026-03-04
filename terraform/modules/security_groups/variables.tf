variable "all_traffic" {
  type    = string
  default = "0.0.0.0/0"
}

variable "http_port" {
  type    = number
  default = 80
}

variable "https_port" {
  type    = number
  default = 443
}

variable "vpc_id" {
  type        = string
  description = "Main VPC id"
}