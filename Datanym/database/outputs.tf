output "db_user" {
  value = var.db_user
}

output "db_password" {
  value = random_string.this.result
}

output "db_name" {
  value = aws_redshiftserverless_namespace.serverless.db_name
}

output "db_endpoint" {
  value = aws_redshiftserverless_workgroup.serverless.endpoint
}
