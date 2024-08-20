
####################### DATA

data "aws_route53_zone" "xtcross-zone" {
  name = "${var.xtcross-domain-name}.com"
}

####################### VARIABLE
variable "environment" { description = "xtcross environment" }
variable "xtcross-domain-name" { description = "xtcross domain name" }
variable "xtcross-loadbalancer-public-name" { description = "xtcross dns name of the alb" }
variable "xtcross-loadbalancer-private-name" { description = "xtcross dns name of the alb" }
variable "xtcross-listener-hostlist" { description = "xtcross the list of listener hostnames" }

####################### RESOURCE

resource "aws_route53_record" "xtcross-service-record-public" {
  for_each = toset(var.xtcross-listener-hostlist)
  zone_id  = data.aws_route53_zone.xtcross-zone.zone_id
  name     = each.key
  type     = "CNAME"
  ttl      = "300"
  records  = [var.xtcross-loadbalancer-public-name]
}

resource "aws_route53_record" "xtcross-service-record-private" {
  for_each = toset(var.xtcross-listener-hostlist)
  zone_id  = data.aws_route53_zone.xtcross-zone.zone_id
  name     = "private-${each.key}"
  type     = "CNAME"
  ttl      = "300"
  records  = [var.xtcross-loadbalancer-private-name]
}
