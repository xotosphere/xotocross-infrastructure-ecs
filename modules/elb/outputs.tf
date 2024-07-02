output "xotocross-alb-listener-arns" {
  value       = { for k in keys(aws_lb_listener.xotocross-http-listener) : k => aws_lb_listener.xotocross-http-listener[k].arn }
  description = "xotocross arns of the alb listeners"
}

output "xotocross-target-group-arns" {
  value       = { for k in keys(aws_lb_target_group.xotocross-tg) : k => aws_lb_target_group.xotocross-tg[k].arn }
  description = "xotocross arns of the target groups"
}

output "xotocross-alb-name" {
  value       = aws_lb.xotocross-alb.dns_name
  description = "xotocross dns name of the alb"
}

output "xotocross-alb-zone-id" {
  value       = aws_lb.xotocross-alb.zone_id
  description = "xotocross zone id of the alb"
}
