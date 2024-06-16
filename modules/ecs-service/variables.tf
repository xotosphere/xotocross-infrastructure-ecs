variable "xotocross-ecs-cluster-id" {
	description = "xotocross ecs cluster id"
}

variable "xotocross-task-family" { 
	description = "xotocross task family"
	type = string 
}

variable "xotocross-container-definition" { 
	description = "xotocross container definition"
	type = string 
}

variable "xotocross-execution-role-arn" { 
	description = "xotocross execution role arn"
	type = string 
}

variable "xotocross-task-role-arn" { 
	description = "xotocross task role arn"
	type = string 
}

variable "xotocross-service-name" { 
	description = "xotocross service name"
	type = string 
}

variable "xotocross-container-name" { 
	description = "xotocross container name"
	type = string 
}

variable "xotocross-container-port" {
  description = "xotocross list of ports"
  type        = list(number)
}

variable "xotocross-desired-count" { 
	description = "xotocross desired count"
	type = number 
}

variable "xotocross-deployment-max" { 
	description = "xotocross deployment max"
	type = number
}

variable "xotocross-deployment-min" { 
	description = "xotocross deployment min"
	type = number
}

variable "xotocross-enable-deployment-circuit-breaker" { 
	description = "xotocross enable deployment circuit breaker"
	type = bool 
}

variable "xotocross-enable-rollback" { 
	description = "xotocross enable rollback"
	type = bool 
}

variable "xotocross-placement-constraint-type" { 
	description = "xotocross placement constraint type"
	type = string 
}

variable "xotocross-placement-constraint-expression" { 
	description = "xotocross placement constraint expression"
	type = string 
}

variable "xotocross-enable-ecs-managed-tags" { 
	description = "xotocross enable ecs managed tags"
	type = bool 
}

variable "xotocross-propagate-tags" { 
	description = "xotocross propagate tags"
	type = string 
}

variable "xotocross-enable-execute-command" { 
	description = "xotocross enable execute command"
	type = bool 
}

variable "xotocross-health-check-grace-period" { 
	description = "xotocross health check grace period"
	type = number 
}

variable "xotocross-iam-role" { 
	description = "xotocross iam role"
	type = string 
}

variable "xotocross-network-mode" { 
	description = "xotocross network mode"
	type = string
}

variable "xotocross-target-group-arn" { 
	description = "xotocross target group arn"
	type = string
}
