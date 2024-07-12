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
				"name": "xotocross : $xotocross-service-name",
				"query": "{cost_project=\"$xotocross-service-name\"}",  
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
					"expr": "{cost_project=\"$xotocross-service-name\"}",
					"refId": "A"
				}
			]
		}
	]
}