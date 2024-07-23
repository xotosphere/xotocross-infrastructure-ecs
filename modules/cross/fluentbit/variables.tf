####################### VARIABLE

variable "region" { description = "xotocross the aws region where the service is deployed" }
variable "environment" { description = "xotocross the deployment environment (e.g., stage, prod)" }
variable "xotocross-domain-name" { description = "xotocross the domain name for the xotocross service" }
variable "xotocross-service-name" { description = "xotocross the name of the xotocross service" }
variable "xotocross-service-version" { description = "xotocross application version" }
variable "xotocross-container-definition" { description = "xotocross container definition for the xotocross service" }
variable "xotocross-enable-monitor" { description = "xotocross flag to indicate if monitoring is enabled" }
variable "xotocross-healthcheck-pathlist" { description = "xotocross health check paths for the xotocross service" }
variable "xotocross-listener-hostlist" { description = "xotocross listener hosts for the xotocross service" }
variable "xotocross-container-portlist" { description = "xotocross container ports for the xotocross service" }
variable "xotocross-host-portlist" { description = "xotocross host ports for the xotocross service" }
