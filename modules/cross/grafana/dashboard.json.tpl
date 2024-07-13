{
	"uid": "Loki",
	"title": "xotocross logs : ${cost_project}",
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
				"name": "xotocross : ${cost_project}",
				"query": "{cost_project=${cost_project}}",  
				"refresh": 1,
				"type": "query"
			}
		]
	},
	"panels": [
		{
			"title": "xotocross logs ${cost_project}",
			"type": "logs",
			"datasource": "Loki",
			"targets": [
				{
					"expr": "{cost_project=${cost_project}}",
					"refId": "A"
				}
			]
		}
	],
	"schemaVersion": 16,
	"version": 1,
	"meta": {
		"isStarred": false
	}
}