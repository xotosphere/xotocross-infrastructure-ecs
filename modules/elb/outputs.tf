output "alb_listener_arn" {
  description = "xotocross arn of the alb listener"
  value = aws_lb_listener.xotocross-http-listener.arn
}

output "xotocross-target-group-arn" {
  description = "xotocross arn of the target group"
  value = aws_lb_target_group.xotocross-tg.arn
}