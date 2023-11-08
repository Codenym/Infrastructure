resource "aws_rds_cluster" "datanym-postgres" {
  cluster_identifier      = "datanym-postgres"
  engine                  = "aurora-postgresql"
  engine_mode             = "serverless"
  database_name           = "datanym"
  enable_http_endpoint    = true
  master_username         = var.DATANYM_POSTGRES_USER
  master_password         = var.DATANYM_POSTGRES_PASSWORD
  backup_retention_period = 1
  skip_final_snapshot     = true

  scaling_configuration {
    auto_pause               = true
    min_capacity             = 2
    max_capacity             = 8
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}