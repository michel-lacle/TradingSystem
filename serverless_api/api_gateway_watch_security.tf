resource "aws_api_gateway_deployment" "watch_security" {
  rest_api_id = aws_api_gateway_rest_api.trading_api.id
  stage_name = "prod"

  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(aws_api_gateway_integration.watch_security),
    )))
  }

  depends_on = [aws_api_gateway_method.watch_security]
}

resource "aws_api_gateway_resource" "watch_security" {
  path_part   = aws_lambda_function.watch_security.function_name
  parent_id   = aws_api_gateway_rest_api.trading_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.trading_api.id
}

resource "aws_api_gateway_method" "watch_security" {
  rest_api_id   = aws_api_gateway_rest_api.trading_api.id
  resource_id   = aws_api_gateway_resource.watch_security.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "watch_security" {
  rest_api_id             = aws_api_gateway_rest_api.trading_api.id
  resource_id             = aws_api_gateway_resource.watch_security.id
  http_method             = aws_api_gateway_method.watch_security.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.watch_security.invoke_arn
}

resource "aws_lambda_permission" "watch_security" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.watch_security.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.trading_api.execution_arn}/*/*/*"
}