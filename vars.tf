variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "Choose cidr for your VPC"
  type        = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}
