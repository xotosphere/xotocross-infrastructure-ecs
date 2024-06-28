
# resource "aws_route53_record" "xotocross-ns-records" {
#   zone_id = aws_route53_zone.xotocross-zone.zone_id
#   name    = var.xotocross-domain-name
#   type    = "NS"
#   ttl     = "300"
#   records = [
#     "ns-773.awsdns-32.net.",
#     "ns-1313.awsdns-36.org.",
#     "ns-1540.awsdns-00.co.uk.",
#     "ns-9.awsdns-01.com."
#   ]

#   # lifecycle {
#   #   prevent_destroy = true
#   # }
# }

resource "aws_route53_record" "domain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.xotocross-domain-name
  type    = "A"
  alias {
    name                   = var.xotocross-alb-dns-name
    zone_id                = var.xotocross-alb-zone-id
    evaluate_target_health = true
  }
}


# This record points your subdomain (environment) to the ALB
resource "aws_route53_record" "subdomain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.environment}.${var.xotocross-subdomain-name}.${var.xotocross-domain-name}"
  type    = "CNAME"
  ttl     = "300"
  records = [var.xotocross-alb-dns-name]
}