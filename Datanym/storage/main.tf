resource "aws_s3_bucket" "datanym-pipeline" {
  bucket = "datanym-pipeline"

  tags = {
    Name        = "Dagster Data Pipeline Bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket" "datanym-lambda-deployment" {
  bucket = "datanym-datasette-lambda-deployment"

  tags = {
    Name        = "Datasette deployment bucket"
    Environment = "Production"
  }
}