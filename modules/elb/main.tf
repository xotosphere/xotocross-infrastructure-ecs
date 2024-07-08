resource "aws_lb" "xotocross-alb" {
  name                             = var.xotocross-alb-name
  internal                         = false
  load_balancer_type               = "application"
  subnets                          = var.xotocross-public-subnets
  security_groups                  = [var.xotocross-alb-sg]
  desync_mitigation_mode           = "defensive"
  enable_cross_zone_load_balancing = true
  enable_http2                     = true
  idle_timeout                     = 300
  ip_address_type                  = "ipv4"

  tags = {
    Name        = var.xotocross-alb-name
    environment = var.environment
  }
}

resource "aws_lb_listener" "xotocross-http-listener" {
  for_each = toset([for idx in range(0, length(var.xotocross-listener-ports)) : tostring(idx)])

  load_balancer_arn = aws_lb.xotocross-alb.arn
  port              = var.xotocross-listener-ports[each.value]
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.xotocross-tg[each.value].arn
  }

  tags = {
    Name        = "${var.xotocross-alb-name}-listener-${each.value}"
    environment = var.environment
  }
}

resource "aws_lb_listener" "xotocross-http-listener-200" {
  load_balancer_arn = aws_lb.xotocross-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<html><head><style>body{background-color:#282c34;display:flex;flex-direction:column;align-items:center;justify-content:center;font-size:calc(10px + 2vmin);color:white;}</style></head><body><h1>Welcome to our website! be sure to check the url 😊</h1></body></html>"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "xotocross-http-listener-rule" {
  for_each = toset([for idx in range(0, length(var.xotocross-host-ports)) : tostring(idx)])

  listener_arn = aws_lb_listener.xotocross-http-listener-200.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.xotocross-tg[each.value].arn
  }

  condition {
    host_header {
      values = [var.xotocross-listener-hosts[each.value]]
    }
  }
}

resource "aws_lb_target_group" "xotocross-tg" {
  for_each = toset([for idx in range(0, length(var.xotocross-host-ports)) : tostring(idx)])

  name                          = "${var.xotocross-tg-name}-${each.value}"
  port                          = var.xotocross-host-ports[each.value]
  protocol                      = "HTTP"
  target_type                   = var.xotocross-target-type
  vpc_id                        = var.xotocross-vpc-id
  load_balancing_algorithm_type = "round_robin"

  health_check {
    enabled             = false
    healthy_threshold   = var.xotocross-healthy-threshhold
    unhealthy_threshold = var.xotocross-unhealthy-threshhold
    interval            = var.xotocross-healthcheck-interval
    matcher             = "200"
    path                = var.xotocross-healthcheck-paths[each.value]
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = var.xotocross-healthcheck-timeout
  }

  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }

  tags = {
    Name        = "${var.xotocross-tg-name}-${each.value}"
    environment = var.environment
  }
}
