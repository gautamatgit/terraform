variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "aws_region" {
    default = "ap-south-1"
}

variable "vpc_cidr" {
    default = "172.20.0.0/16"
}

variable "public_subnet_cidr" {
    default = "172.20.10.0/24"
}

variable "private_subnet_cidr" {
    default = "172.20.20.0/24"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "AWS_AMI" {
  type = string
}

variable "AWS_INSTANCE_TYPE" {
	type = string
}
