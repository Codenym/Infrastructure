output "db_url" {
  value = "postgresql://${var.db_user}:${aws_db_instance.this.password}@${aws_db_instance.this.address}:${aws_db_instance.this.port}/${var.db_name}"
}