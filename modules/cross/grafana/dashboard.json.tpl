{
	"uid": "Loki",
	"title": "xotocross logs \"${cost_project}\"",
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
				"name": "xotocross : \"${cost_project}\"",
				"query": "{cost_project=\"${cost_project}\"}",  
				"refresh": 1,
				"type": "query"
			}
		]
	},
	"panels": [
		{
			"title": "xotocross logs \"${cost_project}\"",
			"type": "logs",
			"datasource": "Loki",
			"targets": [
				{
					"expr": "{cost_project=\"${cost_project}\"}",
					"refId": "A"
				}
			]
		},
		{
			"id": 20,
			"title": "cpu busy - ${cost_project}",
			"type": "gauge",
			"targets": [
				{
					"expr": "(((count(count(node_cpu_seconds_total{cost_project=\"${cost_project}\"}) by (cpu))) - avg(sum by (mode)(rate(node_cpu_seconds_total{mode='idle',cost_project=\"${cost_project}\"}[$__rate_interval])))) * 100) / count(count(node_cpu_seconds_total{cost_project=\"${cost_project}\"}) by (cpu))",
					"hide": false,
					"intervalFactor": 1,
					"legendFormat": "",
					"refId": "A",
					"step": 240
				}
			]
		},
		{
			"id": 21,
			"title": "memory usage - ${cost_project}",
			"type": "gauge",
			"targets": [
				{
					"expr": "node_memory_MemTotal_bytes{cost_project=\"${cost_project}\"} - node_memory_MemFree_bytes{cost_project=\"${cost_project}\"} - node_memory_Buffers_bytes{cost_project=\"${cost_project}\"} - node_memory_Cached_bytes{cost_project=\"${cost_project}\"}",
					"hide": false,
					"intervalFactor": 1,
					"legendFormat": "",
					"refId": "B",
					"step": 240
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