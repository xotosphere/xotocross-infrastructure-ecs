resource "aws_cloudwatch_log_group" "xotocross-ecs-loggroup" {
	name = var.xotocross-loggroup-name
  retention_in_days = 14
}
