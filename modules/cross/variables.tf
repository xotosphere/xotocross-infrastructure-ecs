variable "xotocross-service-name" {
  description = "The name of the xotocross service"
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., staging, production)"
  type        = string
}

variable "xotocross-domain-name" {
  description = "The domain name for the xotocross service"
  type        = string
}

variable "region" {
  description = "The AWS region where the service is deployed"
  type        = string
}

variable "xotocross-container-definition" {
  description = "Container definition for the xotocross service"
  type        = list(any)
  default     = []
}

variable "xotocross-has-monitor" {
  description = "Flag to indicate if monitoring is enabled"
  type        = bool
}

variable "xotocross-healthcheck-paths" {
  description = "Health check paths for the xotocross service"
  type        = list(string)
  default     = []
}

variable "xotocross-listener-hosts" {
  description = "Listener hosts for the xotocross service"
  type        = list(string)
  default     = []
}
