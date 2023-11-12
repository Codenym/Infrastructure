
locals {
  tags = {
    Env = var.env
  }
}

resource "aws_secretsmanager_secret" "this" {
  name = "${var.env}_credential"

  tags = merge(local.tags, {
    Name = "${var.env}-credential"
  })
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = <<EOF
{
  "DATABASE_URL": "${var.db_url}"
}
EOF
}