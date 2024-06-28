resource "aws_route53_record" "domain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.xotocross-domain-name
  type    = "CNAME"
  records = [var.xotocross-alb-dns-name]
  ttl     = "300"
}

resource "aws_route53_record" "subdomain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.environment}.${var.xotocross-subdomain-name}.${var.xotocross-domain-name}"
  type    = "CNAME"
  records = [var.xotocross-alb-dns-name]
  ttl     = "300"
}