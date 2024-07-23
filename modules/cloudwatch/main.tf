####################### VARIABLE

variable "environment" { description = "xotocross environment (e.g. dev, stage, prod, infra)" }
variable "xotocross-ecs-loggroup-name" { description = "xotocross log group name" }
variable "xotocross-loggroup-retention" { description = "xotocross retention days for the loggroup" }

####################### RESOURCE

resource "aws_cloudwatch_log_group" "xotocross-ecs-loggroup" {
	name = var.xotocross-ecs-loggroup-name
  retention_in_days = var.xotocross-loggroup-retention
}
