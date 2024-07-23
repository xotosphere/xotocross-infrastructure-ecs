####################### OUTPUTS

output "xotocross-loadbalaner-listener-arnlist" {
  value = { for k in keys(aws_lb_listener.xotocross-http-listener) : k => aws_lb_listener.xotocross-http-listener[k].arn }
  description = "xotocross arn list of the alb listeners"
}

output "xotocross-targetgroup-arnlist" {
  value = { for k in keys(aws_lb_target_group.xotocross-targetgroup) : k => aws_lb_target_group.xotocross-targetgroup[k].arn }
  description = "xotocross arn list of the target groups"
}

output "xotocross-loadbalaner-name" {
  value = aws_lb.xotocross-loadbalaner.dns_name
  description = "xotocross dns name of the alb"
}

output "xotocross-loadbalaner-zone-id" {
  value = aws_lb.xotocross-loadbalaner.zone_id
  description = "xotocross zone id of the alb"
}

####################### VARIABLES

variable "environment" { description = "xotocross environment (e.g. dev, stage, prod, infra)" }
variable "region" { description = "xotocross region" }
variable "xotocross-loadbalaner-name" { description = "xotocross name of the alb" }
variable "xotocross-public-subnetlist" { description = "xotocross list of public subnet ids to place the alb in" }
variable "xotocross-loadbalaner-securitygroup" { description = "xotocross list of security group ids to attach to the alb" }
variable "xotocross-listener-portlist" { description = "xotocross list of ports for the listeners" }
variable "xotocross-host-portlist" { description = "xotocross list of target ports for the listeners" }
variable "xotocross-domain-name" { description = "xotocross domain name" }
variable "xotocross-targetgroup-name" { description = "xotocross name of the target group" }
variable "xotocross-target-type" { description = "xotocross type of targets for the target group" }
variable "xotocross-vpc-id" { description = "xotocross id of the vpc where the target group will be created" }
variable "xotocross-healthy-threshhold" { description = "xotocross number of consecutive successful health checks required to consider a target healthy" }
variable "xotocross-unhealthy-threshhold" { description = "xotocross number of consecutive failed health checks required to consider a target unhealthy" }
variable "xotocross-healthcheck-interval" { description = "xotocross interval between health checks (in seconds)"}
variable "xotocross-healthcheck-pathlist" { description = "xotocross path of the health check endpoint" }
variable "xotocross-healthcheck-timeout" { description = "xotocross timeout for the health check (in seconds)" }
variable "xotocross-listener-hostlist" { description = "xotocross list of hosts for the listeners" }

####################### DATA

data "external" "certificate" {
  program = ["bash", "-c", "arn=$(aws acm list-certificates --region ${var.region} | jq -r '.CertificateSummaryList[] | select(.DomainName == \"${var.xotocross-domain-name}.com\" and (.Status == \"ISSUED\" or .Status == \"PENDING_VALIDATION\")) | .CertificateArn // \"\"'); if [ -z \"$arn\" ]; then echo -n '{\"arn\": \"\"}'; else echo -n '{\"arn\": \"$arn\"}'; fi"]
}

####################### RESOURCE

# resource "aws_cognito_user_pool" "xotocross-cognito-pool" {
#   name = "xotocross-${var.environment}-pool"

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

# resource "aws_cognito_user_pool_client" "xotocross-cognito-client" {
#   name = "xotocross-${var.environment}-client"

#   user_pool_id = aws_cognito_user_pool.xotocross-cognito-pool.id

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

# resource "aws_cognito_user_pool_domain" "xotocross-cognito-domain" {
#   domain          = "authorizer.${var.xotocross-subdomain-name}.${var.xotocross-domain-name}.com"
#   user_pool_id    = aws_cognito_user_pool.xotocross-cognito-pool.id
# }

resource "aws_lb" "xotocross-loadbalaner" {
  name = var.xotocross-loadbalaner-name
  internal = false
  load_balancer_type = "application"
  subnets = var.xotocross-public-subnetlist
  security_groups = [var.xotocross-loadbalaner-securitygroup]
  desync_mitigation_mode = "defensive"
  enable_cross_zone_load_balancing = true
  enable_http2 = true
  idle_timeout = 300
  ip_address_type = "ipv4"
  
  tags = {
    Name = var.xotocross-loadbalaner-name
    environment = var.environment
  }
}

resource "aws_lb_listener" "xotocross-http-listener" {
  for_each = toset([for idx in range(0, length(var.xotocross-listener-hostlist)) : tostring(idx)])

  load_balancer_arn = aws_lb.xotocross-loadbalaner.arn
  port = var.xotocross-listener-portlist[each.value]
  
  certificate_arn = data.external.certificate.result["arn"] == "" ? null : data.external.certificate.result["arn"]
  
  protocol   = data.external.certificate.result["arn"] == "" ? "HTTP" : "HTTPS"

  # default_action {
  #   type = "authenticate-cognito"
  #   authenticate_cognito {
  #     user_pool_client_id = aws_cognito_user_pool_client.xotocross-cognito-client.id
  #     user_pool_arn       = aws_cognito_user_pool.xotocross-cognito-pool.arn
  #     user_pool_domain    = aws_cognito_user_pool_domain.xotocross-cognito-domain.domain
  #   }
  # }

  lifecycle {
    create_before_destroy = true
  }

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.xotocross-targetgroup[each.value].arn
  }

  tags = {
    Name = "${var.xotocross-loadbalaner-name}-listener-${each.value}"
    environment = var.environment
  }
}

resource "aws_lb_listener" "xotocross-http-listener-200" {
  load_balancer_arn = aws_lb.xotocross-loadbalaner.arn
  port = 80
  protocol   = data.external.certificate.result["arn"] == "" ? "HTTP" : "HTTPS"

  certificate_arn = data.external.certificate.result["arn"] == "" ? null : data.external.certificate.result["arn"]

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<html><head><style>body{background-color:#282c34;display:flex;flex-direction:column;align-items:center;justify-content:center;font-size:calc(10px + 2vmin);color:white;}</style></head><body><h1>Welcome to our website! be sure to check the url 😊</h1></body></html>"
      status_code = "200"
    }
  }
}

# resource "aws_lb_listener_rule" "xotocross-http-cognito-rule" {
#   for_each = toset([for idx in range(0, length(var.xotocross-listener-hostlist)) : tostring(idx)])
  
#   listener_arn = aws_lb_listener.xotocross-http-listener-200.arn
#   priority     = 100

#   action {
#     type = "authenticate-cognito"
#     authenticate_cognito {
#       user_pool_arn       = aws_cognito_user_pool.xotocross-cognito-pool.arn
#       user_pool_client_id = aws_cognito_user_pool_client.xotocross-cognito-client.id
#       user_pool_domain    = aws_cognito_user_pool_domain.xotocross-cognito-domain.domain
#     }
#   }

#   action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.xotocross-targetgroup[each.value].arn
#   }

#   condition {
#     path_pattern {
#       values = ["/*"]
#     }
#   }
# }

resource "aws_lb_listener_rule" "xotocross-http-listener-rule" {
  for_each = toset([for idx in range(0, length(var.xotocross-listener-hostlist)) : tostring(idx)])
  
  listener_arn = aws_lb_listener.xotocross-http-listener-200.arn

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.xotocross-targetgroup[each.value].arn
  }

  condition {
    host_header {
      values = [var.xotocross-listener-hostlist[each.value]]
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "xotocross-targetgroup" {
  for_each = toset([for idx in range(0, length(var.xotocross-listener-hostlist)) : tostring(idx)])

  name = "${var.xotocross-targetgroup-name}-${each.value}"
  port = var.xotocross-host-portlist[each.value]
  protocol   = data.external.certificate.result["arn"] == "" ? "HTTP" : "HTTPS"

  target_type = var.xotocross-target-type
  vpc_id = var.xotocross-vpc-id
  load_balancing_algorithm_type = "round_robin"

  health_check {
    enabled = true
    healthy_threshold = var.xotocross-healthy-threshhold
    unhealthy_threshold = var.xotocross-unhealthy-threshhold
    interval = var.xotocross-healthcheck-interval
    matcher = "200"
    path = var.xotocross-healthcheck-pathlist[each.value]
    port = "traffic-port"
    protocol   = data.external.certificate.result["arn"] == "" ? "HTTP" : "HTTPS"

    timeout = var.xotocross-healthcheck-timeout
  }

  stickiness {
    cookie_duration = 86400
    enabled = false
    type = "lb_cookie"
  }

  tags = {
    Name = "${var.xotocross-targetgroup-name}-${each.value}"
    environment = var.environment
  }
}
