resource "aws_api_gateway_resource" "get_watch_list" {
  parent_id = aws_api_gateway_rest_api.trading_api.root_resource_id
  path_part = aws_lambda_function.get_watch_list.function_name
  rest_api_id = aws_api_gateway_rest_api.trading_api.id
}

resource "aws_api_gateway_method" "get_watch_list" {
  authorization = "NONE"
  http_method = "GET"
  resource_id = aws_api_gateway_resource.get_watch_list.id
  rest_api_id = aws_api_gateway_rest_api.trading_api.id
}

resource "aws_api_gateway_integration" "get_watch_list" {
  http_method = aws_api_gateway_method.get_watch_list.http_method
  resource_id = aws_api_gateway_resource.get_watch_list.id
  rest_api_id = aws_api_gateway_rest_api.trading_api.id
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.get_watch_list.invoke_arn
}

resource "aws_api_gateway_deployment" "get_watch_list" {
  rest_api_id = aws_api_gateway_rest_api.trading_api.id
  stage_name = "prod"

  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(aws_api_gateway_integration.get_watch_list),
    )))
  }
}

resource "aws_lambda_permission" "get_watch_list" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_watch_list.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.trading_api.execution_arn}/*/*/*"
}