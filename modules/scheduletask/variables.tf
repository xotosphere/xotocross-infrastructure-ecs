variable "environment" { description = "xotocross environment (e.g. [development, staging, production])" }
variable "xotocross-layer-name" { description = "xotocross name of the layer" }
variable "xotocross-function-name" { description = "xotocross name of the function" }
variable "xotocross-bucket-name" { description = "xotocross name of the s3 bucket" }
variable "xotocross-lambda-role-arn" { description = "xotocross arn of the lambda policy function" }
variable "xotocross-email" { description = "xotocross emails subscriptions" }
variable "xotocross-log-group-name" { description = "xotocross cluster log group name for lambda" }
