resource "aws_s3_bucket" "datanym-pipeline" {
  bucket = "datanym-pipeline"

  tags = {
    Name        = "Dagster Data Pipeline Bucket"
    Environment = "Production"
  }
}

resource "aws_iam_user" "dagster_user" {
  name = "dagster_user"
}

resource "aws_iam_user_login_profile" "dagster_user_login_profile" {
  user          = aws_iam_user.dagster_user.name
  password_reset_required = false

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
    ]
  }
}

output "dagster_user_password" {
  value = aws_iam_user_login_profile.dagster_user_login_profile.password
}

resource "aws_iam_policy" "dagster_s3_policy" {
  name        = "dagster_s3_policy"
  description = "Policy for dagster_s3_role to access dagster-bucket"

  policy = data.aws_iam_policy_document.dagster_bucket_policy_document.json
}

resource "aws_iam_user_policy_attachment" "dagster_s3_attach" {
  user       = aws_iam_user.dagster_user.name
  policy_arn = aws_iam_policy.dagster_s3_policy.arn
}


data "aws_iam_policy_document" "dagster_bucket_policy_document" {
  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      aws_s3_bucket.datanym-pipeline.arn,
      "${aws_s3_bucket.datanym-pipeline.arn}/*"
    ]
  }
}
