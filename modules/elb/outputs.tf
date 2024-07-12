output "xotocross-alb-listener-arnlist" {
  value = { for k in keys(aws_lb_listener.xotocross-http-listener) : k => aws_lb_listener.xotocross-http-listener[k].arn }
  description = "xotocross arn list of the alb listeners"
}

output "xotocross-target-group-arnlist" {
  value = { for k in keys(aws_lb_target_group.xotocross-tg) : k => aws_lb_target_group.xotocross-tg[k].arn }
  description = "xotocross arn list of the target groups"
}

output "xotocross-alb-name" {
  value = aws_lb.xotocross-alb.dns_name
  description = "xotocross dns name of the alb"
}

output "xotocross-alb-zone-id" {
  value = aws_lb.xotocross-alb.zone_id
  description = "xotocross zone id of the alb"
}
