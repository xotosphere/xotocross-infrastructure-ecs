variable "xotocross-alb-name" {
  description = "xotocross name of the alb"
  type = string
}

variable "xotocross-public-subnets" {
  description = "xotocross list of public subnet ids to place the alb in"
}

variable "xotocross-alb-sg" {
  description = "xotocross list of security group ids to attach to the alb"
}

variable "environment" {
  description = "xotocross environment (e.g. development, staging, production)"
  type = string
}

# variable "xotocross-certificate-arn" {
#   description = "xotocross arn of the certificate to use for the alb listener"
#   type = string
# }

variable "xotocross-ports" {
  description = "xotocross list of ports for the listeners"
  type        = list(number)
}

variable "xotocross-create-record" {
  description = "xotocross to create a record"
  type = bool
}

variable "xotocross-domain-name" {
  type = string
  description = "xotocross domain name"
}

variable "xotocross-subdomains" {
  description = "List of subdomains to create"
  type        = list(string)
}

variable "xotocross-tg-name" {
  description = "xotocross name of the target group"
  type = string
}

variable "xotocross-target-type" {
  description = "xotocross type of targets for the target group"
  type = string
}

variable "xotocross-vpc-id" {
  description = "xotocross id of the vpc where the target group will be created"
  type = string
}

variable "xotocross-healthy-threshhold" {
  description = "xotocross number of consecutive successful health checks required to consider a target healthy"
  type = number
}

variable "xotocross-unhealthy-threshhold" {
  description = "xotocross number of consecutive failed health checks required to consider a target unhealthy"
  type = number
}

variable "xotocross-health-check-interval" {
  description = "xotocross interval between health checks (in seconds)"
  type = number
}

variable "xotocross-health-check-path" {
  description = "xotocross path of the health check endpoint"
  type = string
}

variable "xotocross-health-check-timeout" {
  description = "xotocross timeout for the health check (in seconds)"
  type = number
}