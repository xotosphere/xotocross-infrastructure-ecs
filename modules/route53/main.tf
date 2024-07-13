resource "aws_route53_record" "xotocross-service-record" {
  zone_id = data.aws_route53_zone.xotocross-selected-zone.zone_id
  name = "${var.xotocross-subdomain-name}.${var.environment}.${var.xotocross-domain-name}"
  type = "CNAME"
  ttl = "300"
  records = [var.xotocross-alb-name]
}

resource "aws_route53_record" "wildcard-service-record" {
  zone_id = data.aws_route53_zone.xotocross-selected-zone.zone_id
  name = "*.${var.xotocross-subdomain-name}.${var.environment}.${var.xotocross-domain-name}"
  type = "CNAME"
  ttl = "300"
  records = [var.xotocross-alb-name]
}
