# for domain names i was thinking we do the following : 

# so we dont need prod with real urls for now. we can do urls based : 

# we can have service.xotosphere.com for each service as name 
# and then for environment we can have dev, staging, prod as subdomain like the config below 


# resource "aws_route53_record" "domain" {
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = "${var.xotocross-subdomain-name}.${var.xotocross-domain-name}"
#   type    = "A"
#   alias {
#     name                   = var.xotocross-alb-name
#     zone_id                = var.xotocross-alb-zone-id
#     evaluate_target_health = true
#   }
# }

resource "aws_route53_record" "subdomain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.environment}.${var.xotocross-subdomain-name}.${var.xotocross-domain-name}"
  type    = "CNAME"
  ttl     = "300"
  records = [var.xotocross-alb-name]
}

resource "aws_route53_record" "subdomain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "*.${var.environment}.${var.xotocross-subdomain-name}.${var.xotocross-domain-name}"
  type    = "CNAME"
  ttl     = "300"
  records = [var.xotocross-alb-name]
}
