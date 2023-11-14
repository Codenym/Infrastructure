
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
      var.bucket_arn,
      "${var.bucket_arn}/*"
    ]
  }
}


resource "aws_iam_role" "lambda_datasette_role" {
  name = "lambda_datasette_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

# Attach the basic execution role policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_datasette_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}