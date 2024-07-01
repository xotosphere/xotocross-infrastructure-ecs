variable "environment" { description = "xotocross environment (e.g. development, staging, production)" }
variable "xotocross-task-count" { description = "xotocross task count" }
variable "xotocross-service-name" { description = "xotocross name of the service" }
variable "xotocross-function-name" { description = "xotocross name of the function" }
variable "xotocross-lambda-role-arn" { description = "xotocross arn of the lambda policy function" }
variable "xotocross-email" { description = "xotocross emails subscriptions" }
variable "xotocross-log-group-name" { description = "xotocross cluster log group name for lambda" }
