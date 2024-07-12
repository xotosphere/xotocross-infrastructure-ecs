locals {
  xotocross-container-definition-fluentbit = jsondecode(templatefile("${path.module}/aws/task-container.tpl", {
    xotocross-container-name      = "xotocross-${var.xotocross-service-name}-fluentbit"
    xotocross-container-image     = "ghcr.io/xotosphere/fluentbit:latest"
    xotocross-container-cpu       = 0
    xotocross-container-memory    = 256
    xotocross-container-essential = false

    xotocross-container-portmap = jsonencode([
      { containerPort = 24224, hostPort = 24224, protocol = "tcp" },
      { containerPort = 2020, hostPort = 2020, protocol = "tcp" }
    ])

    xotocross-container-environment = jsonencode([
      { name = "ENVIRONMENT", value = var.environment },
      { name = "LOKI_HOST", value = "loki.monitor.${var.environment}.${var.xotocross-domain-name}" },
      { name = "LOKI_PORT", value = "80" },
      { name = "COST_PROJECT_NAME", value = var.xotocross-service-name },
      { name = "COST_PROJECT_VERSION", value = var.xotocross-service-version },
      { name = "FLB_LOG_LEVEL", value = "debug" },
      { name = "AWS_REGION", value = var.region },
      { name = "LOG_GROUP", value = "xotocross-${var.xotocross-service-name}-${var.environment}-log" },
    ])

    xotocross-container-loggroup    = "xotocross-${var.xotocross-service-name}-${var.environment}-log"
    xotocross-container-region      = var.region
    xotocross-container-command     = jsonencode([])
    xotocross-container-dependency  = jsonencode([])
    xotocross-container-entrypoint  = jsonencode([])
    xotocross-container-healthcheck = "null"

    xotocross-container-firelensconfiguration = jsonencode({
      type = "fluentbit",
      options = {
        # enable-log-metadata = "true",
        config-file-type        = "file",
        config-file-value       = "/fluent-bit/etc/fluent-bit-filter.conf"
      }
    })
  }))

  xotocross-container-definition = concat(var.xotocross-container-definition, var.xotocross-enable-monitor ? [local.xotocross-container-definition-fluentbit] : [])
  xotocross-healthcheck-paths    = concat(var.xotocross-healthcheck-paths, var.xotocross-enable-monitor ? ["/api/v1/health"] : [])
  xotocross-listener-hosts       = concat(var.xotocross-listener-hosts, var.xotocross-enable-monitor ? ["fluentbit.${var.xotocross-service-name}.${var.environment}.${var.xotocross-domain-name}"] : [])
  xotocross-container-ports      = concat(var.xotocross-container-ports, var.xotocross-enable-monitor ? [2020, 24224] : [])
  xotocross-host-ports           = concat(var.xotocross-host-ports, var.xotocross-enable-monitor ? [2020, 24224] : [])
}
