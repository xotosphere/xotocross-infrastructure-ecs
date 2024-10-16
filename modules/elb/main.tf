output "xtcross-targetgroup-arnlist" {
  value       = { for k in keys(aws_lb_target_group.xtcross-targetgroup) : k => aws_lb_target_group.xtcross-targetgroup[k].arn }
  description = "xtcross arn list of the target groups"
}

output "xtcross-loadbalancer-name" {
  value       = data.aws_lb.xtcross-loadbalancer.dns_name
  description = "xtcross dns name of the alb"
}

output "xtcross-loadbalancer-zone-id" {
  value       = data.aws_lb.xtcross-loadbalancer.zone_id
  description = "xtcross zone id of the alb"
}

output "xtcross-https-enabled" {
  value       = local.hasCert
  description = "xtcross has certificate"
}

######################

variable "environment" { description = "xtcross environment" }
variable "region" { description = "xtcross region" }
variable "xtcross-loadbalancer-name" { description = "xtcross name of the alb" }
variable "xtcross-private-subnetlist" { description = "xtcross list of private subnet ids to place the alb in" }
variable "xtcross-loadbalancer-securitygroup" { description = "xtcross list of security group ids to attach to the alb" }
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

data "aws_lb" "xtcross-loadbalancer" {
  name = var.xtcross-loadbalancer-name
}

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

resource "aws_lb_listener" "xtcross-https-redirection" {
  count             = local.hasCert ? 1 : 0
  load_balancer_arn = data.aws_lb.xtcross-loadbalancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "xtcross-http-listener" {
  load_balancer_arn = data.aws_lb.xtcross-loadbalancer.arn
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
  for_each     = toset([for idx in range(0, length(var.xtcross-listener-hostlist)) : tostring(idx)])
  listener_arn = aws_lb_listener.xtcross-http-listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.xtcross-targetgroup[each.value].arn
  }

  tags = {
    Name        = "${var.xtcross-targetgroup-name}-${each.value}"
    environment = var.environment
  }

  condition {
    host_header {
      values = ["private-${var.xtcross-listener-hostlist[each.value]}", var.xtcross-listener-hostlist[each.value]]
    }
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
  deregistration_delay          = 0

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
