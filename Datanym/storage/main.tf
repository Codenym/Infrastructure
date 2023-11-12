resource "aws_s3_bucket" "datanym-pipeline" {
  bucket = "datanym-pipeline"

  tags = {
    Name        = "Dagster Data Pipeline Bucket"
    Environment = "Production"
  }
}