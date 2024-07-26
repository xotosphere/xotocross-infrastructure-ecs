####################### LOCAL

locals {
  xtcross-container-fluentbit = jsondecode(templatefile("${path.module}/aws/task-container.tpl", {
    xtcross-container-name = "xtcross-${var.xtcross-service-name}-fluentbit"
    xtcross-container-image = "ghcr.io/xotosphere/fluentbit:latest"
    xtcross-container-cpu = 0
    xtcross-container-memory = 256
    xtcross-container-essential = false
    xtcross-container-portmap = jsonencode([{ containerPort = 24224, hostPort = 24224, protocol = "tcp" },{ containerPort = 2020, hostPort = 2020, protocol = "tcp" }])
    xtcross-container-environment = jsonencode([
      { name = "ENVIRONMENT", value = var.environment },
      { name = "LOKI_HOST", value = var.environment == "production" ? "loki.${var.xtcross-domain-name}.com" : "loki.${var.environment}.${var.xtcross-domain-name}.com" },
      { name = "LOKI_PORT", value = "80" },
      { name = "COST_PROJECT_NAME", value = var.xtcross-service-name },
      { name = "COST_PROJECT_VERSION", value = var.xtcross-service-version },
      { name = "FLB_LOG_LEVEL", value = "debug" },
      { name = "AWS_REGION", value = var.region },
      { name = "LOG_GROUP", value = "/aws/ecs/xtcross-${var.xtcross-service-name}-${var.environment}-log" },
    ])
    xtcross-container-loggroup = "/aws/ecs/xtcross-${var.xtcross-service-name}-${var.environment}-log"
    xtcross-container-region = var.region
    xtcross-container-command = jsonencode([])
    xtcross-container-dependency = jsonencode([])
    xtcross-container-entrypoint = jsonencode([])
    xtcross-container-healthcheck = "null"

    xtcross-container-firelensconfiguration = jsonencode({
      type = "fluentbit",
      options = {
        config-file-type = "file",
        config-file-value = "/fluent-bit/etc/fluent-bit-filter.conf"
      }
    })
  }))

  xtcross-container-definition = concat(var.xtcross-container-definition, var.xtcross-enable-monitor ? [local.xtcross-container-fluentbit] : [])
  xtcross-healthcheck-pathlist = concat(var.xtcross-healthcheck-pathlist, var.xtcross-enable-monitor ? ["/api/v1/health"] : [])
  xtcross-listener-hostlist = concat(var.xtcross-listener-hostlist, var.xtcross-enable-monitor ? ["fluentbit.${var.environment}.${var.xtcross-domain-name}.com"] : [])
  xtcross-container-portlist = concat(var.xtcross-container-portlist, var.xtcross-enable-monitor ? [2020, 24224] : [])
  xtcross-host-portlist = concat(var.xtcross-host-portlist, var.xtcross-enable-monitor ? [2020, 24224] : [])
}
