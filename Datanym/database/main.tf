locals {
  tags = {
    Env = var.env
  }
}

resource "random_string" "this" {
  length  = 16
  upper   = true
  numeric = true
  special = false
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.db_identifier}-${var.env}-subnet-group"
  subnet_ids = var.vpc_private_subnet_ids

  tags = merge(local.tags, {
    Name = "${var.env}-subnet-group"
  })
}

resource "aws_db_instance" "this" {
  identifier             = "${var.db_identifier}-${var.env}"
  allocated_storage      = 10
  db_name                = var.db_name
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  availability_zone      = element(var.azs, 0)
  instance_class         = "db.t3.micro"
  username               = var.db_user
  password               = random_string.this.result
  skip_final_snapshot    = true
  deletion_protection    = false
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = merge(local.tags, {
    Name = "${var.env}-db"
  })
}