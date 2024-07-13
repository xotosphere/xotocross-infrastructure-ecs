{
	"dashboard": {
		"id": null,
		"title": "dashboard - ${cost_project}",
		"panels": [
      {
        "id": 22,
        "title": "logs - ${cost_project}",
        "type": "logs",
        "gridPos": {
          "h": 8,
          "w": 3,
          "x": 0,
          "y": 9
        },
        "targets": [
          {
            "expr": "{cost_project=\"$cost_project\"}",
            "refId": "C"
          }
        ]
      },
			{
				"id": 20,
				"title": "cpu busy - ${cost_project}",
				"type": "gauge",
				"gridPos": {
					"h": 4,
					"w": 3,
					"x": 0,
					"y": 1
				},
				"options": {
					"orientation": "horizontal",
					"reduceOptions": {
						"calcs": ["lastNotNull"],
						"fields": "",
						"values": false
					},
					"showThresholdLabels": false,
					"showThresholdMarkers": true
				},
				"targets": [
					{
						"expr": "(((count(count(node_cpu_seconds_total{cost_project=\"$cost_project\"}) by (cpu))) - avg(sum by (mode)(rate(node_cpu_seconds_total{mode='idle',cost_project=\"$cost_project\"}[$__rate_interval])))) * 100) / count(count(node_cpu_seconds_total{cost_project=\"$cost_project\"}) by (cpu))",
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
				"gridPos": {
					"h": 4,
					"w": 3,
					"x": 0,
					"y": 5
				},
				"options": {
					"orientation": "horizontal",
					"reduceOptions": {
						"calcs": ["lastNotNull"],
						"fields": "",
						"values": false
					},
					"showThresholdLabels": false,
					"showThresholdMarkers": true
				},
				"targets": [
					{
						"expr": "node_memory_MemTotal_bytes{cost_project=\"$cost_project\"} - node_memory_MemFree_bytes{cost_project=\"$cost_project\"} - node_memory_Buffers_bytes{cost_project=\"$cost_project\"} - node_memory_Cached_bytes{cost_project=\"$cost_project\"}",
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
		"version": 1
	},
	"meta": {
		"isStarred": false
	}
}