######################

output "xtcross-loadbalaner-listener-arnlist" {
  value       = { for k in keys(aws_lb_listener.xtcross-http-listener) : k => aws_lb_listener.xtcross-http-listener[k].arn }
  description = "xtcross arn list of the alb listeners"
}

output "xtcross-targetgroup-arnlist" {
  value       = { for k in keys(aws_lb_target_group.xtcross-targetgroup) : k => aws_lb_target_group.xtcross-targetgroup[k].arn }
  description = "xtcross arn list of the target groups"
}

output "xtcross-loadbalaner-name" {
  value       = aws_lb.xtcross-loadbalaner.dns_name
  description = "xtcross dns name of the alb"
}

output "xtcross-loadbalaner-zone-id" {
  value       = aws_lb.xtcross-loadbalaner.zone_id
  description = "xtcross zone id of the alb"
}

output "xtcross-https-enabled" {
  value       = local.hasCert
  description = "xtcross has certificate"
}

######################

variable "environment" { description = "xtcross environment" }
variable "region" { description = "xtcross region" }
variable "xtcross-loadbalaner-name" { description = "xtcross name of the alb" }
variable "xtcross-public-subnetlist" { description = "xtcross list of public subnet ids to place the alb in" }
variable "xtcross-private-subnetlist" { description = "xtcross list of private subnet ids to place the alb in" }
variable "xtcross-loadbalaner-securitygroup" { description = "xtcross list of security group ids to attach to the alb" }
variable "xtcross-listener-portlist" { description = "xtcross list of ports for the listeners" }
variable "xtcross-host-portlist" { description = "xtcross list of target ports for the listeners" }
variable "xtcross-domain-name" { description = "xtcross domain name" }
variable "xtcross-targetgroup-name" { description = "xtcross name of the target group" }
variable "xtcross-target-type" { description = "xtcross type of targets for the target group" }
variable "xtcross-vpc-id" { description = "xtcross id of the vpc where the target group will be created" }
variable "xtcross-healthy-threshhold" { description = "xtcross number of consecutive successful health checks required to consider a target healthy" }
variable "xtcross-unhealthy-threshhold" { description = "xtcross number of consecutive failed health checks required to consider a target unhealthy" }
variable "xtcross-healthcheck-interval" { description = "xtcross interval between health checks (in seconds)" }
variable "xtcross-healthcheck-pathlist" { description = "xtcross path of the health check endpoint" }
variable "xtcross-healthcheck-timeout" { description = "xtcross timeout for the health check (in seconds)" }
variable "xtcross-listener-hostlist" { description = "xtcross list of hosts for the listeners" }

######################

data "external" "xtcross-certificate" {
  program = ["bash", "-c", "arn=$(aws acm list-certificates --region eu-west-3 | jq -r '.CertificateSummaryList[] | select(.DomainName == \"*.${var.environment}.${var.xtcross-domain-name}.com\" and .Status == \"ISSUED\") | .CertificateArn' | head -n 1); jq --arg arn \"$arn\" '{\"arn\": $arn}'"]
}

resource "local_file" "certificate_snapshot" {
  content  = local.hasCert ? data.external.xtcross-certificate.result["arn"] : "HTTP MODE"
  filename = "${path.module}/certificate_snapshot.json"
}

######################

locals {
  prod_cert_arn = data.external.xtcross-certificate.result["arn"]
  hasCert       = local.prod_cert_arn != ""
  certificate   = local.hasCert ? local.prod_cert_arn : null
}

resource "aws_lb" "xtcross-loadbalaner" {
  name                             = var.xtcross-loadbalaner-name
  internal                         = var.environment == "production" ? false : true
  load_balancer_type               = "application"
  subnets                          = var.environment == "production" ? var.xtcross-public-subnetlist : var.xtcross-private-subnetlist
  security_groups                  = [var.xtcross-loadbalaner-securitygroup]
  desync_mitigation_mode           = "defensive"
  enable_cross_zone_load_balancing = true
  enable_http2                     = true
  idle_timeout                     = 300
  ip_address_type                  = "ipv4"

  tags = {
    Name        = var.xtcross-loadbalaner-name
    environment = var.environment
  }
}

resource "aws_lb_listener" "xtcross-http-listener" {
  for_each          = toset([for idx in range(0, length(var.xtcross-listener-hostlist)) : tostring(idx)])
  load_balancer_arn = aws_lb.xtcross-loadbalaner.arn
  port              = var.xtcross-listener-portlist[each.value]
  certificate_arn   = local.certificate
  protocol          = local.hasCert ? "HTTPS" : "HTTP"
  ssl_policy        = local.hasCert ? "ELBSecurityPolicy-2016-08" : null

  lifecycle {
    create_before_destroy = true
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.xtcross-targetgroup[each.value].arn
  }

  tags = {
    Name        = "${var.xtcross-loadbalaner-name}-listener-${each.value}"
    environment = var.environment
  }
}

resource "aws_lb_listener" "xtcross-http-listener-200" {
  load_balancer_arn = aws_lb.xtcross-loadbalaner.arn
  port              = local.hasCert ? 443 : 80
  certificate_arn   = local.certificate
  protocol          = local.hasCert ? "HTTPS" : "HTTP"
  ssl_policy        = local.hasCert ? "ELBSecurityPolicy-2016-08" : null

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<html><head><style>body{background-color:#282c34;display:flex;flex-direction:column;align-items:center;justify-content:center;font-size:calc(10px + 2vmin);color:white;}</style></head><body><h1>Welcome to our website! be sure to check the url 😊</h1></body></html>"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "xtcross-http-listener-rule" {
  for_each = toset([for idx in range(0, length(var.xtcross-listener-hostlist)) : tostring(idx)])

  listener_arn = aws_lb_listener.xtcross-http-listener-200.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.xtcross-targetgroup[each.value].arn
  }

  condition {
    host_header {
      values = [var.xtcross-listener-hostlist[each.value]]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "xtcross-targetgroup" {
  for_each                      = toset([for idx in range(0, length(var.xtcross-listener-hostlist)) : tostring(idx)])
  name                          = "${var.xtcross-targetgroup-name}-${each.value}"
  port                          = var.xtcross-host-portlist[each.value]
  protocol                      = "HTTP"
  target_type                   = var.xtcross-target-type
  vpc_id                        = var.xtcross-vpc-id
  load_balancing_algorithm_type = "round_robin"

  health_check {
    enabled             = true
    healthy_threshold   = var.xtcross-healthy-threshhold
    unhealthy_threshold = var.xtcross-unhealthy-threshhold
    interval            = var.xtcross-healthcheck-interval
    matcher             = "200"
    path                = var.xtcross-healthcheck-pathlist[each.value]
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = var.xtcross-healthcheck-timeout
  }

  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }

  tags = {
    Name        = "${var.xtcross-targetgroup-name}-${each.value}"
    environment = var.environment
  }
}

# toremove and think about : for the vpn connection to IP WAFF
# resource "aws_wafv2_web_acl" "xtcross-waf" {
#   name        = "xtcross-${var.environment}-lbwaf"
#   description = "WAF for ${var.xtcross-loadbalaner-name}"
#   scope       = "REGIONAL"

#   default_action {
#     allow {}
#   }

#   rule {
#     name     = "rule-1"
#     priority = 1

#     action {
#       block {}
#     }

#     statement {
#       ip_set_reference_statement {
#         arn = aws_wafv2_ip_set.example.arn
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = false
#       metric_name                = "friendly-rule-metric-name"
#       sampled_requests_enabled   = false
#     }
#   }

#   visibility_config {
#     cloudwatch_metrics_enabled = false
#     metric_name                = "friendly-metric-name"
#     sampled_requests_enabled   = false
#   }
# }

# resource "aws_wafv2_web_acl_association" "xtcross-waf-association" {
#   resource_arn = aws_lb.xtcross-loadbalaner.arn
#   web_acl_arn  = aws_wafv2_web_acl.xtcross-waf.arn
# }