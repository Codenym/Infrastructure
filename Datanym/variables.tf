variable "env" {
  default = "staging"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1b"]
}