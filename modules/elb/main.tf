
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
  for_each = toset([for idx in range(0, length(var.xotocross-ports)) : tostring(idx)])

  load_balancer_arn = aws_lb.xotocross-alb.arn
  port              = var.xotocross-ports[each.value]
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

resource "aws_lb_target_group" "xotocross-tg" {
  for_each = toset([for idx in range(0, length(var.xotocross-ports)) : tostring(idx)])

  name                          = "${var.xotocross-tg-name}-${each.value}"
  port                          = var.xotocross-ports[each.value]
  protocol                      = "HTTP"
  target_type                   = var.xotocross-target-type
  vpc_id                        = var.xotocross-vpc-id
  load_balancing_algorithm_type = "round_robin"

  health_check {
    enabled             = true
    healthy_threshold   = var.xotocross-healthy-threshhold
    unhealthy_threshold = var.xotocross-unhealthy-threshhold
    interval            = var.xotocross-health-check-interval
    matcher             = "200"
    path                = var.xotocross-health-check-path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = var.xotocross-health-check-timeout
  }

  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }

  tags = {
    environment = var.environment
    Name        = "${var.xotocross-tg-name}-${each.value}"
  }
}
