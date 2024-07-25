####################### DATA

data "aws_route53_zone" "xtcross-zone" {
  name = "${var.xtcross-domain-name}.com"
}

####################### VARIABLE

variable "environment" { description = "xtcross environment" }
variable "xtcross-domain-name" { description = "xtcross domain name" }
variable "xtcross-loadbalaner-name" { description = "xtcross dns name of the alb" }
variable "xtcross-loadbalaner-zone-id" { description = "xtcross zone id of the alb" }
variable "xtcross-subdomain-name" { description = "xtcross subdomain name" }

####################### RESOURCE

resource "aws_route53_record" "xtcross-service-record" {
  zone_id = data.aws_route53_zone.xtcross-zone.zone_id
  name    = var.environment == "production" ? "*.${var.xtcross-domain-name}.com" : "${var.xtcross-subdomain-name}.${var.environment}.${var.xtcross-domain-name}.com"
  type    = "CNAME"
  ttl     = "300"
  records = [var.xtcross-loadbalaner-name]
}

resource "aws_route53_record" "xtcross-wildcard-record" {
  zone_id = data.aws_route53_zone.xtcross-zone.zone_id
  name    = var.environment == "production" ? "*.${var.xtcross-domain-name}.com" : "*.${var.xtcross-subdomain-name}.${var.environment}.${var.xtcross-domain-name}.com"
  type    = "CNAME"
  ttl     = "300"
  records = [var.xtcross-loadbalaner-name]
}

# resource "aws_route53_record" "xtcross-cognito-record" {
#   zone_id = data.aws_route53_zone.xtcross-zone.zone_id
#   name    = "authorizer.${var.xtcross-subdomain-name}.${var.xtcross-domain-name}.com"
#   type    = "A"

#   alias {
#     name                   = aws_cognito_user_pool_domain.xtcross-cognito-domain.cloudfront_distribution_arn
#     zone_id                = aws_cognito_user_pool_domain.xtcross-cognito-domain.cloudfront_zone_id
#     evaluate_target_health = false
#   }
# }
# resource "aws_route53_record" "xtcross-cognito-record" {
#   zone_id = data.aws_route53_zone.xtcross-zone.zone_id
#   name    = "authorizer.${var.xtcross-domain-name}.com"
#   type    = "CNAME"
#   ttl     = "300"
#   records = [var.xtcross-loadbalaner-name]
# }

resource "aws_route53_record" "xtcross-cognito-record" {
  zone_id = data.aws_route53_zone.xtcross-zone.zone_id
  name    = "authorizer.${var.xtcross-subdomain-name}.${var.xtcross-domain-name}.com"
  type    = "CNAME"
  ttl     = "300"
  records = [var.xtcross-loadbalaner-name]
}