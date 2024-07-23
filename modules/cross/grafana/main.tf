####################### PROVIDER

terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "3.4.0"
    }
  }
}

provider "grafana" {
  url  = var.environment == "prod" ? "http://grafana.${var.xotocross-domain-name}.com" : "http://grafana.monitor.${var.environment}.${var.xotocross-domain-name}.com"
  auth = "${var.xotocross-username}:${var.xotocross-password}"
}

####################### VARIABLE

variable "environment" { description = "xotocross environment (e.g. dev, stage, prod, infra)" }
variable "xotocross-service-name" { description = "xotocross the name of the xotocross service" }
variable "xotocross-domain-name" { description = "xotocross domain name" }
variable "xotocross-password" { description = "xotocross password" }
variable "xotocross-username" { description = "xotocross username" }

####################### RESOURCE

resource "grafana_dashboard" "xotocross-service-dashboard" {
  config_json = templatefile("${path.module}/dashboard.json.tpl", { cost_project = var.xotocross-service-name, environment = var.environment })
  overwrite   = true
}

resource "local_file" "foo" {
  content  = templatefile("${path.module}/dashboard.json.tpl", { cost_project = var.xotocross-service-name, environment = var.environment })
  filename = "${path.module}/dashboard_output.json"
}
