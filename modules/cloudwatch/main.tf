resource "aws_cloudwatch_log_group" "xotocross-log-group" {
	name = var.xotocross-log-group-name
  retention_in_days = 14
}
