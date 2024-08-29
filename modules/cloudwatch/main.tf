####################### VARIABLE

variable "environment" { description = "xtcross environment" }
variable "xtcross-ecs-loggroup-name" { description = "xtcross log group name" }
variable "xtcross-loggroup-retention" { description = "xtcross retention days for the loggroup" }

####################### RESOURCE

resource "aws_cloudwatch_log_group" "xtcross-ecs-loggroup" {
  name = var.xtcross-ecs-loggroup-name
  retention_in_days = var.xtcross-loggroup-retention
}
