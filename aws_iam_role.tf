
resource "aws_iam_role" "lambda_execution" {
  name_prefix = "${var.name_prefix}-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_execution_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_execution_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}


resource "aws_iam_role_policy_attachment" "lambda_execution" {
  role = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
