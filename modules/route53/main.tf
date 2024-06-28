resource "aws_route53_record" "domain" {
  zone_id = var.xotocross-zone-id
  name    = var.xotocross-domain-name
  type    = "A"

  alias {
    name                   = var.xotocross-alb-dns-name
    zone_id                = var.xotocross-alb-zone-id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "subdomain" {
  zone_id = var.xotocross-zone-id
  name    = "${var.xotocross-subdomain-name}.${var.xotocross-domain-name}"
  type    = "A"

  alias {
    name                   = var.xotocross-alb-dns-name
    zone_id                = var.xotocross-alb-zone-id
    evaluate_target_health = true
  }
}