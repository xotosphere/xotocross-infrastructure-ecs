locals {
  xotocross-container-definition-fluentbit = jsondecode(templatefile("${path.module}/aws/task-container.tpl", {
    xotocross-container-name      = "${var.xotocross-service-name}-fluentbit"
    xotocross-container-image     = "ghcr.io/xotosphere/fluentbit:latest"
    xotocross-container-cpu       = 0
    xotocross-container-memory    = 256
    xotocross-container-essential = false
    xotocross-port-mapping        = jsonencode([{ containerPort = 24224, hostPort = 24224, protocol = "tcp" }])
    xotocross-environment = jsonencode([
      { name = "environment", value = var.environment },
      { name = "LOKI_HOST", value = "loki.monitor.${var.environment}.${var.xotocross-domain-name}" },
      { name = "LOKI_PORT", value = "80" },
      { name = "COST_PROJECT_NAME", value = var.xotocross-service-name },
      { name = "COST_PROJECT_VERSION", value = "1.0.0" },
      { name = "ENVIRONMENT", value = var.environment },
      { name = "FLB_LOG_LEVEL", value = "debug" }
    ])
    xotocross-log-group-name        = "${var.xotocross-service-name}-${var.environment}-logs"
    xotocross-region                = var.region
    xotocross-container-command     = jsonencode([])
    xotocross-container-dependency  = jsonencode([])
    xotocross-container-entrypoint  = jsonencode([])
    xotocross-container-healthcheck = "null"
    xotocross-container-firelensconfiguration = jsonencode({
      type = "fluentbit",
      options = {
        enable-ecs-log-metadata = "true",
        config-file-type        = "file",
        config-file-value       = "/fluent-bit/etc/fluent-bit-filter.conf"
      }
    })
  }))

  xotocross-container-list-definition = concat(
    var.xotocross-container-definition,
    var.xotocross-is-application ? [local.xotocross-container-definition-fluentbit] : []
  )
}


resource "aws_ecs_task_definition" "xotocross-ecs-task-definition" {
  family                = var.xotocross-task-family
  container_definitions = jsonencode(local.xotocross-container-list-definition)

  # container_definitions    = jsonencode(var.xotocross-container-definition)
  execution_role_arn       = var.xotocross-execution-role-arn
  task_role_arn            = var.xotocross-task-role-arn
  network_mode             = var.xotocross-network-mode
  requires_compatibilities = ["EC2"]
}

resource "aws_ecs_service" "xotocross-service" {
  name                               = var.xotocross-service-name
  cluster                            = var.xotocross-cluster-name
  task_definition                    = aws_ecs_task_definition.xotocross-ecs-task-definition.arn
  deployment_maximum_percent         = var.xotocross-deployment-max
  deployment_minimum_healthy_percent = var.xotocross-deployment-min
  desired_count                      = var.xotocross-desired-count
  launch_type                        = var.xotocross-ecs-launch-type

  deployment_controller {
    type = "ECS"
  }

  dynamic "load_balancer" {
    for_each = range(0, length(var.xotocross-container-port))
    iterator = count
    content {
      target_group_arn = var.xotocross-target-group-arns[count.value]
      container_name   = var.xotocross-container-definition[count.value].name
      container_port   = var.xotocross-container-port[count.value]
    }
  }

  deployment_circuit_breaker {
    enable   = var.xotocross-enable-deployment-circuit-breaker
    rollback = var.xotocross-enable-rollback
  }

  placement_constraints {
    type       = var.xotocross-placement-constraint-type
    expression = var.xotocross-placement-constraint-expression
  }

  enable_ecs_managed_tags           = var.xotocross-enable-ecs-managed-tags
  propagate_tags                    = var.xotocross-propagate-tags
  enable_execute_command            = var.xotocross-enable-execute-command
  health_check_grace_period_seconds = var.xotocross-health-check-grace-period
}
