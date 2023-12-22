resource "random_string" "this" {
  length  = 16
  upper   = true
  numeric = true
  special = false
}
resource "aws_iam_role" "RedshiftRole" {
  name = "RedshiftRole"

  assume_role_policy = jsonencode({

    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "redshift.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "redshift_etl_s3_read_only" {
  role       = aws_iam_role.RedshiftRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_security_group" "redshift_security_group" {
  name   = "redshift_security_group"
  vpc_id = "vpc-085b98812685c1cc2"#var.vpc_id#"vpc-63e47f19" # Select this default VPC automatically?"

  ingress {
    description = "Allow traffic from anywhere"
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow traffic to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_iam_user" "Redshift-ETL-user" {
  name = "Redshift-ETL-user"
  # May need to programatically create access key
}

resource "aws_iam_user_policy_attachment" "Reshift-ETL-User-S3-Attach" {
  user       = aws_iam_user.Redshift-ETL-user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"

}
resource "aws_iam_user_policy_attachment" "Reshift-ETL-User-RS-Attach" {
  user       = aws_iam_user.Redshift-ETL-user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess"
}

# Create the Redshift Serverless Namespace
resource "aws_redshiftserverless_namespace" "serverless" {
  namespace_name      = "redshift-serverless-namespace"
  db_name             = "redshift-serverless-db"
  admin_username      = var.db_user
  admin_user_password = random_string.this.result
  iam_roles           = [aws_iam_role.RedshiftRole.arn]

  tags = {
    Name        = "redshift-serverless-namespace"
  }
}

################################################

# Create the Redshift Serverless Workgroup
resource "aws_redshiftserverless_workgroup" "serverless" {
  depends_on = [aws_redshiftserverless_namespace.serverless]

  namespace_name = aws_redshiftserverless_namespace.serverless.id
  workgroup_name = "redshift-serverless-workgroup"
  base_capacity  = 32

  security_group_ids = [ aws_security_group.redshift_security_group.id ]
  publicly_accessible = true

  tags = {
    Name        = "redshift-serverless-workgroup"
  }
}
