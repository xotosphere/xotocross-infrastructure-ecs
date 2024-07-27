
####################### DATA

data "aws_route53_zone" "xtcross-zone" {
  name = "${var.xtcross-domain-name}.com"
}

####################### VARIABLE
variable "environment" { description = "xtcross environment" }
variable "xtcross-domain-name" { description = "xtcross domain name" }
variable "xtcross-loadbalaner-name" { description = "xtcross dns name of the alb" }
variable "xtcross-loadbalaner-zone-id" { description = "xtcross zone id of the alb" }
variable "xtcross-service-name" { description = "xtcross the name of the xtcross service" }

####################### RESOURCE

# resource "aws_route53_record" "xtcross-service-record" {
#   count   = var.environment == "production" ? 0 : 1
#   zone_id = data.aws_route53_zone.xtcross-zone.zone_id
#   name    = "*.${var.environment}.${var.xtcross-domain-name}.com"
#   type    = "CNAME"
#   ttl     = "300"
#   records = [var.xtcross-loadbalaner-name]
# }


# resource "aws_route53_record" "xtcross-service-record" {
#   zone_id = data.aws_route53_zone.xtcross-zone.zone_id
#   name    = var.environment == "production" ? "*.${var.xtcross-domain-name}.com" : "*.${var.environment}.${var.xtcross-domain-name}.com"
#   type    = "CNAME"
#   ttl     = "300"
#   records = [var.xtcross-loadbalaner-name]
# }

resource "aws_route53_record" "xtcross-service-record" {
  zone_id = data.aws_route53_zone.xtcross-zone.zone_id
  name    = "*${var.xtcross-service-name}-${var.xtcross-service-name}.${var.environment}.${var.xtcross-domain-name}.com"
  type    = "CNAME"
  ttl     = "300"
  records = [var.xtcross-loadbalaner-name]
}