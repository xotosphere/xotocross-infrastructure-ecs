
####################### DATA

data "aws_route53_zone" "xtcross-zone" {
  name = "${var.xtcross-domain-name}.com"
}

####################### VARIABLE
variable "environment" { description = "xtcross environment" }
variable "xtcross-domain-name" { description = "xtcross domain name" }
variable "xtcross-loadbalaner-name" { description = "xtcross dns name of the alb" }
variable "xtcross-listener-hostlist" { description = "xtcross the list of listener hostnames" }

####################### RESOURCE

resource "aws_route53_record" "xtcross-service-record" {
  for_each = toset(var.xtcross-listener-hostlist)
  zone_id  = data.aws_route53_zone.xtcross-zone.zone_id
  name     = each.key
  type     = "CNAME"
  ttl      = "300"
  records  = [var.xtcross-loadbalaner-name]
}
