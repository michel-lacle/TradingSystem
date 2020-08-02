data "archive_file" "get_watch_list" {
  type = "zip"

  source_file = "${path.module}/lambda_get_watch_list.py"
  output_path = "${path.module}/lambda_get_watch_list.zip"
}

resource "aws_lambda_function" "get_watch_list" {
  filename = "${path.module}/lambda_get_watch_list.zip"
  function_name = "get_watch_list"
  handler = "lambda_get_watch_list.main"
  role = aws_iam_role.this.arn
  runtime = "python3.7"

  source_code_hash = filebase64sha256("${path.module}/lambda_get_watch_list.zip")

  environment {
    variables = {
      DEBUG = false
      SLACK_WEBHOOK = var.slack_webhook
    }
  }

  # in seconds
  timeout = 10
}

resource "aws_cloudwatch_log_group" "get_watch_list" {
  name              = "/aws/lambda/get_watch_list"
  retention_in_days = 14
}