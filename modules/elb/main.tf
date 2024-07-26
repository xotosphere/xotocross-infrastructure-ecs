####################### OUTPUT

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

####################### VARIABLE

variable "environment" { description = "xtcross environment" }
variable "region" { description = "xtcross region" }
variable "xtcross-loadbalaner-name" { description = "xtcross name of the alb" }
variable "xtcross-public-subnetlist" { description = "xtcross list of public subnet ids to place the alb in" }
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

####################### DATA

data "external" "certificate" {
  program = ["bash", "-c", "arn=$(aws acm list-certificates --region eu-west-3 | jq -r '.CertificateSummaryList[] | select(.DomainName == \"*.xotosphere.com\" and .Status == \"ISSUED\") | .CertificateArn' | head -n 1); jq --arg arn \"$arn\" '{\"arn\": $arn}'"]
}

resource "local_file" "certificate_snapshot" {
  content  = data.external.certificate.result["arn"]
  filename = "${path.module}/certificate_snapshot.json"
}

####################### RESOURCE

# resource "aws_cognito_user_pool" "xtcross-cognito-pool" {
#   name = "xtcross-${var.environment}-pool"

#   password_policy {
#     minimum_length    = 8
#     require_lowercase = true
#     require_numbers   = true
#     require_symbols   = true
#     require_uppercase = true
#   }

#   mfa_configuration = "ON"
#   software_token_mfa_configuration {
#     enabled = true
#   }

#   account_recovery_setting {
#     recovery_mechanism {
#       name     = "verified_email"
#       priority = 1
#     }
#   }
# }

# resource "aws_cognito_user_pool_client" "xtcross-cognito-client" {
#   name = "xtcross-${var.environment}-client"

#   user_pool_id = aws_cognito_user_pool.xtcross-cognito-pool.id

#   explicit_auth_flows = [
#     "ALLOW_USER_PASSWORD_AUTH",
#     "ALLOW_REFRESH_TOKEN_AUTH"
#   ]

#   allowed_oauth_flows = ["code", "implicit"]
#   allowed_oauth_scopes = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]

#   generate_secret = true
#   callback_urls = ["http://www.example.com/callback"]
#   logout_urls = ["http://www.example.com/logout"]

#   allowed_oauth_flows_user_pool_client = true
# }

# resource "aws_cognito_user_pool_domain" "xtcross-cognito-domain" {
#   domain          = "authorizer.${var.xtcross-subdomain-name}.${var.xtcross-domain-name}.com"
#   user_pool_id    = aws_cognito_user_pool.xtcross-cognito-pool.id
# }

resource "aws_lb" "xtcross-loadbalaner" {
  name                             = var.xtcross-loadbalaner-name
  internal                         = false
  load_balancer_type               = "application"
  subnets                          = var.xtcross-public-subnetlist
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
  for_each = toset([for idx in range(0, length(var.xtcross-listener-hostlist)) : tostring(idx)])

  load_balancer_arn = aws_lb.xtcross-loadbalaner.arn
  port              = var.xtcross-listener-portlist[each.value]
  certificate_arn   = data.external.certificate.result["arn"]
  protocol          = data.external.certificate.result["arn"] == "" ? "HTTP" : "HTTPS"
  ssl_policy        = data.external.certificate.result["arn"] == "" ? null : "ELBSecurityPolicy-2016-08"
  # default_action {
  #   type = "authenticate-cognito"
  #   authenticate_cognito {
  #     user_pool_client_id = aws_cognito_user_pool_client.xtcross-cognito-client.id
  #     user_pool_arn       = aws_cognito_user_pool.xtcross-cognito-pool.arn
  #     user_pool_domain    = aws_cognito_user_pool_domain.xtcross-cognito-domain.domain
  #   }
  # }

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
  port              = data.external.certificate.result["arn"] == "" ? 80 : 443
  # protocol          = data.external.certificate.result["arn"] == "" ? "HTTP" : "HTTPS"
  # certificate_arn   = data.external.certificate.result["arn"] 
  protocol        = data.external.certificate.result["arn"] == "" ? "HTTP" : "HTTPS"
  certificate_arn = data.external.certificate.result["arn"]
  ssl_policy      = data.external.certificate.result["arn"] == "" ? null : "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<html><head><style>body{background-color:#282c34;display:flex;flex-direction:column;align-items:center;justify-content:center;font-size:calc(10px + 2vmin);color:white;}</style></head><body><h1>Welcome to our website! be sure to check the url 😊</h1></body></html>"
      status_code  = "200"
    }
  }
}

# resource "aws_lb_listener_rule" "xtcross-http-cognito-rule" {
#   for_each = toset([for idx in range(0, length(var.xtcross-listener-hostlist)) : tostring(idx)])

#   listener_arn = aws_lb_listener.xtcross-http-listener-200.arn
#   priority     = 100

#   action {
#     type = "authenticate-cognito"
#     authenticate_cognito {
#       user_pool_arn       = aws_cognito_user_pool.xtcross-cognito-pool.arn
#       user_pool_client_id = aws_cognito_user_pool_client.xtcross-cognito-client.id
#       user_pool_domain    = aws_cognito_user_pool_domain.xtcross-cognito-domain.domain
#     }
#   }

#   action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.xtcross-targetgroup[each.value].arn
#   }

#   condition {
#     path_pattern {
#       values = ["/*"]
#     }
#   }
# }

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
  for_each = toset([for idx in range(0, length(var.xtcross-listener-hostlist)) : tostring(idx)])

  name     = "${var.xtcross-targetgroup-name}-${each.value}"
  port     = var.xtcross-host-portlist[each.value]
  protocol = data.external.certificate.result["arn"] == "" ? "HTTP" : "HTTPS"

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
    protocol            = data.external.certificate.result["arn"] == "" ? "HTTP" : "HTTPS"
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
