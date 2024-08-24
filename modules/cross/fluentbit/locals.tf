####################### LOCAL

locals {
  xtcross-container-fluentbit = jsondecode(templatefile("${path.module}/aws/task-container.tpl", {
    xtcross-container-name      = "xtcross-${var.xtcross-service-name}-fluentbit"
    xtcross-container-image     = "ghcr.io/xotosphere/fluentbit:latest"
    xtcross-container-essential = false
    xtcross-container-portmap   = jsonencode(concat(var.xtcross-enable-prometheus ? [{ containerPort = 2020, hostPort = 2020, protocol = "tcp", name = "port-${2020}" }] : [], []))
    xtcross-container-environment = jsonencode([
      { name = "ENVIRONMENT", value = var.environment },
      { name = "LOKI_HOST", value = "xtcross-monitor-loki.${var.environment}.local", },
      { name = "LOKI_PORT", value = "3100" },
      { name = "HTTPS", value = "Off" },
      { name = "HTTPS_VERIFY", value = "Off" },
      { name = "COST_PROJECT_NAME", value = var.xtcross-service-name },
      { name = "COST_PROJECT_VERSION", value = var.xtcross-service-version },
      { name = "FLB_LOG_LEVEL", value = "debug" },
      { name = "AWS_REGION", value = var.region },
      { name = "LOG_GROUP", value = "/aws/ecs/xtcross-${var.xtcross-service-name}-${var.environment}-log" },
    ])
    xtcross-container-command               = jsonencode([])
    xtcross-container-dependency            = jsonencode([])
    xtcross-container-entrypoint            = jsonencode([])
    xtcross-container-healthcheck           = "null"
    xtcross-logconfiguration                = jsonencode({ logDriver = "awslogs", options = { "awslogs-group" = "/aws/ecs/xtcross-${var.xtcross-service-name}-${var.environment}-log", "awslogs-region" = var.region } })
    xtcross-container-firelensconfiguration = jsonencode({ type = "fluentbit", options = { config-file-type = "file", config-file-value = "/fluent-bit/etc/fluent-bit-filter.conf" } })
  }))

  xtcross-container-definition = concat(var.xtcross-enable-monitor ? [local.xtcross-container-fluentbit] : [], var.xtcross-container-definition)
  xtcross-healthcheck-pathlist = var.xtcross-healthcheck-pathlist
  xtcross-listener-hostlist    = var.xtcross-listener-hostlist
  xtcross-container-portlist   = var.xtcross-container-portlist
  xtcross-host-portlist        = var.xtcross-host-portlist
}
