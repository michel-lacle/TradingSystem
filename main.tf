module "serverless-api" {
  source = "./serverless_api"

  name = "trading_api"
  slack_webhook = var.slack_webhook

  contact_tag = "Michel"
}

module "web-app" {
  source = "./web-app"
}