variable "environment" { description = "xotocross environment (e.g. development, staging, production)" }
variable "xotocross-alb-name" { description = "xotocross name of the alb" }
variable "xotocross-public-subnets" { description = "xotocross list of public subnet ids to place the alb in" }
variable "xotocross-alb-sg" { description = "xotocross list of security group ids to attach to the alb" }
variable "xotocross-listener-ports" { description = "xotocross list of ports for the listeners" }
variable "xotocross-host-ports" { description = "xotocross list of target ports for the listeners" }
variable "xotocross-create-record" { description = "xotocross to create a record" }
variable "xotocross-domain-name" { description = "xotocross domain name" }
variable "xotocross-tg-name" { description = "xotocross name of the target group" }
variable "xotocross-target-type" { description = "xotocross type of targets for the target group" }
variable "xotocross-vpc-id" { description = "xotocross id of the vpc where the target group will be created" }
variable "xotocross-healthy-threshhold" { description = "xotocross number of consecutive successful health checks required to consider a target healthy" }
variable "xotocross-unhealthy-threshhold" { description = "xotocross number of consecutive failed health checks required to consider a target unhealthy" }
variable "xotocross-health-check-interval" { description = "xotocross interval between health checks (in seconds)" }
variable "xotocross-health-check-paths" { description = "xotocross path of the health check endpoint" }
variable "xotocross-health-check-timeout" { description = "xotocross timeout for the health check (in seconds)" }
variable "xotocross-listener-hosts" { description = "xotocross list of hosts for the listeners" }

