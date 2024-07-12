variable "region" { description = "xotocross region" }
variable "environment" { description = "xotocross environment (e.g. dev, stage, prod, infra)" }
variable "xotocross-cluster-name" { description = "xotocross ecs cluster name" }
variable "xotocross-task-family" { description = "xotocross task family" }
variable "xotocross-container-definition" { description = "xotocross container definition" }
variable "xotocross-execution-role-arn" { description = "xotocross execution role arn" }
variable "xotocross-task-role-arn" { description = "xotocross task role arn" }
variable "xotocross-service-name" { description = "xotocross service name" }
variable "xotocross-container-port" { description = "xotocross list of ports" }
variable "xotocross-desired-count" { description = "xotocross desired count" }
variable "xotocross-deployment-max" { description = "xotocross deployment max" }
variable "xotocross-deployment-min" { description = "xotocross deployment min" }
variable "xotocross-constraint-placement" { description = "xotocross placement constraint type" }
variable "xotocross-constraint-expression" { description = "xotocross placement constraint expression" }
variable "xotocross-propagate-tags" { description = "xotocross propagate tags" }
variable "xotocross-healthcheck-graceperiod" { description = "xotocross health check grace period" }
variable "xotocross-iam-role" { description = "xotocross iam role" }
variable "xotocross-network-mode" { description = "xotocross network mode" }
variable "xotocross-target-group-arns" { description = "xotocross target group arn" }
variable "xotocross-domain-name" { description = "xotocross domain name" }
variable "xotocross-listener-hosts" { description = "xotocross listener hosts" }
