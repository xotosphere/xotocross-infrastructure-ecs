####################### PROVIDER

terraform {
  required_providers {
    grafana = {
      source = "grafana/grafana"
      version = "3.4.0"
    }
  }
}

provider "grafana" {
  url = "https://grafana-monitor.${var.environment}.${var.xtcross-domain-name}.com"
  auth = "${var.xtcross-username}:${var.xtcross-password}"
}

####################### VARIABLE

variable "environment" { description = "xtcross environment" }
variable "xtcross-service-name" { description = "xtcross the name of the xtcross service" }
variable "xtcross-domain-name" { description = "xtcross domain name" }
variable "xtcross-password" { description = "xtcross password" }
variable "xtcross-username" { description = "xtcross username" }
variable "xtcross-container-namelist" { description = "xtcross list of container names" }
variable "xtcross-enable-monitor" { description = "xtcross enable monitor" }

####################### RESOURCE

locals {
  dashboard_container_panel_list = var.xtcross-enable-monitor ? [
    for container_name in var.xtcross-container-namelist : jsondecode(templatefile("${path.module}/dashboard-container-panel.json.tpl", {
      cost_project = var.xtcross-service-name,
      container_name = container_name
    }))
  ] : []

  dashboard_json = var.xtcross-enable-monitor ? templatefile("${path.module}/dashboard.json.tpl", {
    cost_project = var.xtcross-service-name,
    environment = var.environment,
    dashboard_container_panel_list = join(",", [for item in local.dashboard_container_panel_list : jsonencode(item)])
  }) : ""
}

resource "local_file" "dashboard_snapshot" {
  count = var.xtcross-enable-monitor ? 1 : 0
  content = local.dashboard_json
  filename = "${path.module}/dashboard_snapshot.json"
}

resource "grafana_dashboard" "xtcross-service-dashboard" {
  count = var.xtcross-enable-monitor ? 1 : 0
  config_json = local.dashboard_json
  overwrite = true
}
