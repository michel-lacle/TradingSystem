data "archive_file" "watch_security" {
  type = "zip"

  source_file = "${path.module}/lambda_watch_security.py"
  output_path = "${path.module}/lambda_watch_security.zip"
}

resource "aws_lambda_function" "watch_security" {
  filename = "${path.module}/lambda_watch_security.zip"
  function_name = "watch_security"
  role = aws_iam_role.this.arn
  handler = "lambda_watch_security.main"

  source_code_hash = filebase64sha256("${path.module}/lambda_watch_security.zip")

  runtime = "python3.7"

  environment {
    variables = {
      DEBUG = "false"
      SLACK_WEBHOOK = var.slack_webhook
    }
  }

  # in seconds
  timeout = 10

  tags = {
    Name = var.name
    Contact = var.contact_tag
  }

  depends_on = [
    data.archive_file.watch_security, aws_cloudwatch_log_group.watch_security]
}

resource "aws_cloudwatch_log_group" "watch_security" {
  name              = "/aws/lambda/watch_security"
  retention_in_days = 14
}