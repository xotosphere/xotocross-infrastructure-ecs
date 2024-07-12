
resource "grafana_dashboard" "xotocross-service-dashboard" {
  config_json = templatefile("${path.module}/dashboard.json.tpl", {
    xotocross-service-name = var.xotocross-service-name
  })
}