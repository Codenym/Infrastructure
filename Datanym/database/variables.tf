variable "env" {}

variable "vpc_id" {}

variable "vpc_private_subnet_ids" {}

variable "vpc_cidr" {}

variable "azs" {}

variable "db_identifier" {
  default = "myapp"
}

variable "db_name" {
  default = "myapp_db"
}

variable "db_user" {
  default = "dbadmin"
}

variable "db_engine" {
  default = "postgres"
}

variable "db_engine_version" {
  default = "13.7"
}