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
