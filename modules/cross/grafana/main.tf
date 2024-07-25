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
  url  = var.environment == "production" ? "http://grafana.${var.xtcross-domain-name}.com" : "http://grafana.monitor.${var.environment}.${var.xtcross-domain-name}.com"
  auth = "${var.xtcross-username}:${var.xtcross-password}"
}

####################### VARIABLE

variable "environment" { description = "xtcross environment" }
variable "xtcross-service-name" { description = "xtcross the name of the xtcross service" }
variable "xtcross-domain-name" { description = "xtcross domain name" }
variable "xtcross-password" { description = "xtcross password" }
variable "xtcross-username" { description = "xtcross username" }

####################### RESOURCE

locals {
  dashboard_container_panel_list = [
    templatefile("${path.module}/dashboard-container-panel.json.tpl", {
      cost_project   = var.xtcross-service-name,
      container_name = "xtcross-demo-frontend"
    }),
    templatefile("${path.module}/dashboard-container-panel.json.tpl", {
      cost_project   = var.xtcross-service-name,
      container_name = "xtcross-demo-backend"
    })
  ]
  dashboard_json = templatefile("${path.module}/dashboard.json.tpl", {
    cost_project                   = var.xtcross-service-name,
    environment                    = var.environment,
    dashboard_container_panel_list = local.dashboard_container_panel_list
  })
}

resource "grafana_dashboard" "xtcross-service-dashboard" {
  config_json = local.dashboard_json
  overwrite   = true
}

resource "local_file" "foo" {
  content  = local.dashboard_json
  filename = "${path.module}/dashboard_output.json"
}
