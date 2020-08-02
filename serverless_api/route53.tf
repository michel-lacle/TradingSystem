data "aws_route53_zone" "this" {
  name         = "f1kart.com."
  private_zone = false
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "trading-api.${data.aws_route53_zone.this.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [replace(replace(aws_api_gateway_deployment.get_watch_list.invoke_url, "https://", ""),"/prod","")]
}