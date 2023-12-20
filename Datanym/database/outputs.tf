output "db_url" {
  value = "postgresql://${var.db_user}:${random_string.this.result}@${aws_redshift_cluster.redshift-cluster-1.endpoint}:${aws_redshift_cluster.redshift-cluster-1.port}/${aws_redshift_cluster.redshift-cluster-1.database_name}"
}