terraform {
  required_providers {
    grafana = {
      source = "grafana/grafana"
      version = "3.4.0"
    }
  }
}

provider "grafana" {
  url  = var.environment == "prod" ? "http://grafana.${var.xotocross-domain-name}" : "http://grafana.monitor.${var.environment}.${var.xotocross-domain-name}"
  auth = "${var.xotocross-username}:${var.xotocross-password}"
}

resource "grafana_dashboard" "xotocross-service-dashboard" {
  config_json = templatefile("${path.module}/dashboard.json.tpl", {cost_project = var.xotocross-service-name, environment = var.environment})
  overwrite = true
}