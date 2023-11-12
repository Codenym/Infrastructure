resource "aws_security_group" "this" {
  name   = "${var.env}-db-sg"
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = [var.vpc_cidr]
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${var.env}-db-sg"
  })
}