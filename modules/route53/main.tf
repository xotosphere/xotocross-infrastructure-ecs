variable "environment" { description = "xtcross environment" }
variable "xtcross-domain-name" { description = "xtcross domain name" }
variable "xtcross-loadbalaner-name" { description = "xtcross dns name of the alb" }
variable "xtcross-loadbalaner-zone-id" { description = "xtcross zone id of the alb" }

data "aws_route53_zone" "xtcross-zone" {
  name = "${var.xtcross-domain-name}.com"
}

data "external" "xtcross-record-exist" {
  program = ["bash", "-c", "aws route53 list-resource-record-sets --hosted-zone-id ${data.aws_route53_zone.xtcross-zone.zone_id} --query \"ResourceRecordSets[?Name=='*.${var.environment}.${var.xtcross-domain-name}.com.']\" --output json | jq -c '{exist: . | length > 0}'"]
}

locals {
  records_to_create = {for k in toset(["production", "wildcard"]) : k => k if var.environment == k && data.external.xtcross-record-exist.result.exist == "false"}
}

resource "aws_route53_record" "xtcross-service-record" {
  for_each = local.records_to_create

  zone_id = data.aws_route53_zone.xtcross-zone.zone_id
  name    = each.key == "production" ? "*.${var.xtcross-domain-name}.com" : "*.${var.environment}.${var.xtcross-domain-name}.com"
  type    = "CNAME"
  ttl     = "300"
  records = [var.xtcross-loadbalaner-name]
}