output "xotocross-alb-listener-arns" {
  value = { for k in keys(aws_lb_listener.xotocross-http-listener) : k => aws_lb_listener.xotocross-http-listener[k].arn }
  description = "The ARNs of the ALB listeners"
}

output "xotocross-target-group-arns" {
  description = "xotocross arns of the target groups"
  value = { for k in keys(aws_lb_target_group.xotocross-tg) : k => aws_lb_target_group.xotocross-tg[k].arn }
}