{
	"uid": "Loki",
	"title": "xotocross logs : ${cost_project} - ${environment}",
	"__inputs": [
		{
			"name": "Loki",
			"label": "Loki",
			"description": "",
			"type": "datasource",
			"pluginId": "loki",
			"pluginName": "Loki"
		},
		{
			"name": "DS_PROMETHEUS",
			"label": "Prometheus",
			"description": "",
			"type": "datasource",
			"pluginId": "prometheus",
			"pluginName": "Prometheus"
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
		},
		{
			"type": "panel",
			"id": "graph",
			"name": "Graph",
			"version": ""
		},
		{
			"type": "datasource",
			"id": "prometheus",
			"name": "Prometheus",
			"version": "1.0.0"
		},
		{
			"type": "panel",
			"id": "singlestat",
			"name": "Singlestat",
			"version": ""
		}
	],
	"templating": {
		"list": [
			{
				"name": "xotocross : ${cost_project}",
				"query": "{cost_project=${cost_project}}",  
				"refresh": 1,
				"type": "query"
			},
      {
        "current": {
          "selected": false,
          "text": "default",
          "value": "default"
        },
        "error": null,
        "hide": 0,
        "includeAll": false,
        "label": "datasource",
        "multi": false,
        "name": "DS_PROMETHEUS",
        "options": [],
        "query": "prometheus",
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "type": "datasource"
