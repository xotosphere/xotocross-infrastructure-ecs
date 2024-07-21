resource "aws_cloudwatch_log_group" "xotocross-ecs-loggroup" {
	name = var.xotocross-ecs-loggroup-name
  retention_in_days = var.xotocross-loggroup-retention
}
