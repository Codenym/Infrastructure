# Zips and gets the hash of the zipped content.  If hash changes, the lambda function will be updated with new deployment package
data "archive_file" "deployment_package" {
  type             = "zip"
  source_dir       = var.deployment_directory #  ie "inputs/datasette_deployment/fixtures/deployment_package"
  output_file_mode = "0666" # No file content changes == no new hash == no new deploy
  output_path      = join("", [var.deployment_directory, ".zip"]) # "inputs/datasette_deployment/fixtures/deployment_package.zip"
}


resource "aws_lambda_function" "datasette_lambda" {
  function_name    = var.function_name
  role             = var.lambda_role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.10"
  filename         = data.archive_file.deployment_package.output_path
  memory_size      = var.memory_size
  source_code_hash = data.archive_file.deployment_package.output_base64sha256

}

resource "aws_lambda_permission" "allow_apigw" {
  statement_id           = "url"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.datasette_lambda.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
}

# Create the Function URL
resource "aws_lambda_function_url" "datasette_url" {
  function_name      = aws_lambda_function.datasette_lambda.function_name
  authorization_type = "NONE"
}

#output "datasette_url" {
#  value = aws_lambda_function_url.datasette_url.function_url
#}