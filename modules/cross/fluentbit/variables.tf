####################### VARIABLE

variable "region" { description = "xtcross the aws region where the service is deployed" }
variable "environment" { description = "xtcross environment" }
variable "xtcross-domain-name" { description = "xtcross the domain name for the xtcross service" }
variable "xtcross-service-name" { description = "xtcross the name of the xtcross service" }
variable "xtcross-service-version" { description = "xtcross application version" }
variable "xtcross-container-definition" { description = "xtcross container definition for the xtcross service" }
variable "xtcross-enable-monitor" { description = "xtcross flag to indicate if monitoring is enabled" }
variable "xtcross-healthcheck-pathlist" { description = "xtcross health check paths for the xtcross service" }
variable "xtcross-listener-hostlist" { description = "xtcross listener hosts for the xtcross service" }
variable "xtcross-container-portlist" { description = "xtcross container ports for the xtcross service" }
variable "xtcross-host-portlist" { description = "xtcross host ports for the xtcross service" }
variable "xtcross-enable-prometheus" { description = "xtcross flag to indicate if prometheus is enabled" }
