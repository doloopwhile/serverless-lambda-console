resource "random_id" "suffix" {
  byte_length = 8
}

resource "aws_lambda_function" "update_ecs_service" {
  function_name = "${var.name_prefix}-web-${random_id.suffix.hex}"
  filename = data.archive_file.lambda.output_path
  role = aws_iam_role.lambda_execution.arn
  handler = "main.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime = "ruby2.7"
  memory_size = 128
  timeout = 30

  environment {
  }

  lifecycle {
    ignore_changes = [
      filename,
    ]
  }
  tags = var.tags
}

data "archive_file" "lambda" {
  type = "zip"
  source_dir = "lambda"
  output_path = "/.upload/lambda.zip"
}
