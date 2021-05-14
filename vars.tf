variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "Choose cidr for your VPC"
  type        = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "web_instance_type" {
  default = "t2.micro"
  type    = string
}

variable "web_ami" {
  default = {
    us-east-1 = "ami-0d5eff06f840b45e9"
    ap-south-1 = "ami-010aff33ed5991201"
  }
  type    = map(string)
}

