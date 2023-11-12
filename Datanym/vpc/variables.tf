variable "env" {}

variable "azs" {}

variable "vpc_cidr" {}

variable "public_subnets_cidr" {
  type    = list(any)
  default = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "private_subnets_cidr" {
  type    = list(any)
  default = ["10.0.64.0/19", "10.0.96.0/19"]
}