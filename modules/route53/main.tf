resource "aws_route53_zone" "xotocross-zone" {
  name = var.xotocross-domain-name
}

resource "aws_route53_record" "domain" {
  zone_id = aws_route53_zone.xotocross-zone.zone_id
  name    = var.xotocross-domain-name
  type    = "A"

  alias {
    name                   = var.xotocross-alb-dns-name
    zone_id                = var.xotocross-alb-zone-id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "subdomain" {
  zone_id = aws_route53_zone.xotocross-zone.zone_id
  name    = "${var.xotocross-subdomain-name}.${var.xotocross-domain-name}"
  type    = "A"

  alias {
    name                   = var.xotocross-alb-dns-name
    zone_id                = var.xotocross-alb-zone-id
    evaluate_target_health = true
  }
}