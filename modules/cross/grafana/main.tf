terraform {
  required_providers {
    grafana = {
      source = "grafana/grafana"
      version = "3.4.0"
    }
  }
}

provider "grafana" {
  url  = "http://grafana.monitor.${var.environment}.${var.xotocross-domain-name}"
  auth = "admin:${var.xotocross-password}"
}

resource "grafana_dashboard" "xotocross-service-dashboard" {
  config_json = templatefile("${path.module}/dashboard.json.tpl", {
    xotocross-service-name = var.xotocross-service-name
  })
  overwrite = true
}