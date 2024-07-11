variable "region" { description = "xotocross region" }
variable "environment" { description = "xotocross environment (e.g. dev, stage, prod)" }
variable "xotocross-cluster-name" { description = "xotocross ecs cluster name" }
variable "xotocross-task-family" { description = "xotocross task family" }
variable "xotocross-container-definition" { description = "xotocross container definition" }
variable "xotocross-execution-role-arn" { description = "xotocross execution role arn" }
variable "xotocross-task-role-arn" { description = "xotocross task role arn" }
variable "xotocross-service-name" { description = "xotocross service name" }
variable "xotocross-container-port" { description = "xotocross list of ports" }
variable "xotocross-desired-count" { description = "xotocross desired count" }
variable "xotocross-ecs-launch-type" { description = "xotocross launch type" }
variable "xotocross-deployment-max" { description = "xotocross deployment max" }
variable "xotocross-deployment-min" { description = "xotocross deployment min" }
variable "xotocross-enable-deployment-circuit-breaker" { description = "xotocross enable deployment circuit breaker" }
variable "xotocross-enable-rollback" { description = "xotocross enable rollback" }
variable "xotocross-placement-constraint-type" { description = "xotocross placement constraint type" }
variable "xotocross-placement-constraint-expression" { description = "xotocross placement constraint expression" }
variable "xotocross-enable-ecs-managed-tags" { description = "xotocross enable ecs managed tags" }
variable "xotocross-propagate-tags" { description = "xotocross propagate tags" }
variable "xotocross-enable-execute-command" { description = "xotocross enable execute command" }
variable "xotocross-healthcheck-grace-period" { description = "xotocross health check grace period" }
variable "xotocross-iam-role" { description = "xotocross iam role" }
variable "xotocross-network-mode" { description = "xotocross network mode" }
variable "xotocross-target-group-arns" { description = "xotocross target group arn" }
variable "xotocross-domain-name" { description = "xotocross domain name" }
variable "xotocross-listener-hosts" { description = "xotocross listener hosts" }
