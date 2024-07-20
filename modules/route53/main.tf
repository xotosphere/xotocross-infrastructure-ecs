resource "aws_route53_record" "xotocross-service-record" {
  zone_id = data.aws_route53_zone.xotocross-zone.zone_id
  name =  var.environment == "prod" ? "*.${var.xotocross-domain-name}" : "${var.xotocross-subdomain-name}.${var.environment}.${var.xotocross-domain-name}"
  type = "CNAME"
  ttl = "300"
  records = [var.xotocross-loadbalaner-name]
}

resource "aws_route53_record" "wildcard-service-record" {
  zone_id = data.aws_route53_zone.xotocross-zone.zone_id
  name = var.environment == "prod" ? "*.${var.xotocross-domain-name}" : "*.${var.xotocross-subdomain-name}.${var.environment}.${var.xotocross-domain-name}"
  type = "CNAME"
  ttl = "300"
  records = [var.xotocross-loadbalaner-name]
}
