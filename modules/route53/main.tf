####################### DATA

data "aws_route53_zone" "xtcross-zone" {
  name = "${var.xtcross-domain-name}.com"
}

data "aws_route53_record" "xtcross-service-record-production" {
  count  = var.environment == "production" ? 1 : 0
  zone_id = data.aws_route53_zone.xtcross-zone.zone_id
  name    = "*.${var.xtcross-domain-name}.com"
  type    = "CNAME"
}

data "aws_route53_record" "xtcross-service-record-wildcard" {
  count  = var.environment != "production" ? 1 : 0
  zone_id = data.aws_route53_zone.xtcross-zone.zone_id
  name    = "*.${var.environment}.${var.xtcross-domain-name}.com"
  type    = "CNAME"
}

####################### RESOURCE

resource "aws_route53_record" "xtcross-service-record-production" {
  count  = var.environment == "production" && element(data.aws_route53_record.xtcross-service-record-production.*.records, 0) != var.xtcross-loadbalaner-name ? 1 : 0
  zone_id = data.aws_route53_zone.xtcross-zone.zone_id
  name    = "*.${var.xtcross-domain-name}.com"
  type    = "CNAME"
  ttl     = "300"
  records = [var.xtcross-loadbalaner-name]
}

resource "aws_route53_record" "xtcross-service-record-wildcard" {
  count  = var.environment == "production" && element(data.aws_route53_record.xtcross-service-record-wildcard.*.records, 0) != var.xtcross-loadbalaner-name ? 1 : 0
  zone_id = data.aws_route53_zone.xtcross-zone.zone_id
  name    = "*.${var.environment}.${var.xtcross-domain-name}.com"
  type    = "CNAME"
  ttl     = "300"
  records = [var.xtcross-loadbalaner-name]
}