provider "grafana" {
  url  = "grafana.monitor.${var.environment}.${var.xotocross-domain-name}"
  auth = "admin:${var.xotocross-password}"
}

resource "grafana_dashboard" "xotocross-service-dashboard" {
  config_json = <<EOF
{
  "uid": "Loki",
  "title": "xotocross logs",
  "__inputs": [
    {
      "name": "Loki",
      "label": "Loki",
      "description": "",
      "type": "datasource",
      "pluginId": "loki",
      "pluginName": "Loki"
    }
  ],
  "__requires": [
    {
      "type": "panel",
      "id": "logs",
      "name": "Logs",
      "version": ""
    },
    {
      "type": "grafana",
      "id": "grafana",
      "name": "Grafana",
      "version": "7.3.7"
    }
  ],
  "templating": {
    "list": [
      {
        "name": "xotocross-service-name",
        "query": "your-query-here",  
        "refresh": 1,
        "type": "query"
      }
    ]
  },
  "panels": [
    {
      "title": "xotocross logs",
      "type": "logs",
      "datasource": "Loki",
      "targets": [
        {
          "expr": "{app=\"$xotocross-service-name\"}",
          "refId": "A"
        }
      ]
    }
  ]
}
EOF
}