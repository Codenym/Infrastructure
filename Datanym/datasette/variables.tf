# Lambda function name
variable "function_name" {}

# Should be an directory of all contents of deployment package ready to be zipped
variable "deployment_directory" {}

variable "lambda_role_arn" {}

variable "memory_size" { default = 256 }
