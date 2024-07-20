

resource "aws_route53_record" "xotocross-service-record" {
  zone_id = data.aws_route53_zone.xotocross-zone.zone_id
  name    = var.environment == "prod" ? "*.${var.xotocross-domain-name}.com" : "${var.xotocross-subdomain-name}.${var.environment}.${var.xotocross-domain-name}.com"
  type    = "CNAME"
  ttl     = "300"
  records = [var.xotocross-loadbalaner-name]
}

resource "aws_route53_record" "xotocross-wildcard-record" {
  zone_id = data.aws_route53_zone.xotocross-zone.zone_id
  name    = var.environment == "prod" ? "*.${var.xotocross-domain-name}.com" : "*.${var.xotocross-subdomain-name}.${var.environment}.${var.xotocross-domain-name}.com"
  type    = "CNAME"
  ttl     = "300"
  records = [var.xotocross-loadbalaner-name]
}

# resource "aws_route53_record" "xotocross-cognito-record" {
#   zone_id = data.aws_route53_zone.xotocross-zone.zone_id
#   name    = "authorizer.${var.xotocross-domain-name}.com"
#   type    = "A"

#   alias {
#     name                   = aws_cognito_user_pool_domain.xotocross-cognito-domain.cloudfront_distribution_arn
#     zone_id                = aws_cognito_user_pool_domain.xotocross-cognito-domain.cloudfront_zone_id
#     evaluate_target_health = false
#   }
# }
# resource "aws_route53_record" "xotocross-cognito-record" {
#   zone_id = data.aws_route53_zone.xotocross-zone.zone_id
#   name    = "authorizer.${var.xotocross-domain-name}.com"
#   type    = "CNAME"
#   ttl     = "300"
#   records = [var.xotocross-loadbalaner-name]
# }

resource "aws_route53_record" "xotocross-cognito-record" {
  zone_id = data.aws_route53_zone.xotocross-zone.zone_id
  name    = "authorizer.${var.xotocross-domain-name}.com"
  type    = "CNAME"
  ttl     = "300"
  records = [var.xotocross-loadbalaner-name]
}