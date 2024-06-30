variable "environment" { description = "xotocross environment (e.g. [development, staging, production])" }
variable "xotocross-bucket-name" { description = "xotocross name of the s3 bucket to create" }
variable "xotocross-service-name" { description = "xotocross lambda function name" }
variable "xotocross-lambda-role-arn" { description = "xotocross arn of the lambda policy function" }
variable "xotocross-asg-name" { description = "xotocross name of the autoscaling group" }
variable "xotocross-capacity" { description = "xotocross capacity of the autoscaling group" }
variable "xotocross-email" { description = "xotocross emails subscriptions" }
variable "xotocross-log-group-name" { description = "xotocross cluster log group name for lambda" }
