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
      },
      {
        "allValue": null,
        "current": {},
        "datasource": "DS_PROMETHEUS",
        "definition": "",
        "error": null,
        "hide": 0,
        "includeAll": false,
        "label": "Job",
        "multi": false,
        "name": "job",
        "options": [],
        "query": "label_values(node_uname_info, job)",
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 1,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {},
        "datasource": "DS_PROMETHEUS",
        "definition": "label_values(node_uname_info{job=\"$job\"}, instance)",
        "error": null,
        "hide": 0,
        "includeAll": false,
        "label": "Host:",
        "multi": false,
        "name": "node",
        "options": [],
        "query": "label_values(node_uname_info{job=\"$job\"}, instance)",
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 1,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {
          "selected": false,
          "text": "[a-z]+|nvme[0-9]+n[0-9]+",
          "value": "[a-z]+|nvme[0-9]+n[0-9]+"
        },
        "error": null,
        "hide": 2,
        "includeAll": false,
        "label": null,
        "multi": false,
        "name": "diskdevices",
        "options": [
          {
            "selected": true,
            "text": "[a-z]+|nvme[0-9]+n[0-9]+",
            "value": "[a-z]+|nvme[0-9]+n[0-9]+"
          }
        ],
        "query": "[a-z]+|nvme[0-9]+n[0-9]+",
        "skipUrlSync": false,
        "type": "custom"
      }
    ],
	"panels": [
    {
      "collapsed": false,
      "datasource": "DS_PROMETHEUS",
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 261,
      "panels": [],
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "refId": "A"
        }
      ],
      "title": "Quick CPU / Mem / Disk",
      "type": "row"
    },
    {
      "datasource": "DS_PROMETHEUS",
      "description": "Busy state of all CPU cores together",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [
            {
              "options": {
                "match": "null",
                "result": {
                  "text": "N/A"
                }
              },
              "type": "special"
            }
          ],
          "max": 100,
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "rgba(50, 172, 45, 0.97)",
                "value": null
              },
              {
                "color": "rgba(237, 129, 40, 0.89)",
                "value": 85
              },
              {
                "color": "rgba(245, 54, 54, 0.9)",
                "value": 95
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 4,
        "w": 5,
        "x": 0,
        "y": 1
      },
      "id": 20,
      "links": [],
      "options": {
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showThresholdLabels": false,
        "showThresholdMarkers": true
      },
      "pluginVersion": "9.5.20",
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "(((count(count(node_cpu_seconds_total{instance=\"$node\",job=\"$job\"}) by (cpu))) - avg(sum by (mode)(rate(node_cpu_seconds_total{mode='idle',instance=\"$node\",job=\"$job\"}[$__rate_interval])))) * 100) / count(count(node_cpu_seconds_total{instance=\"$node\",job=\"$job\"}) by (cpu))",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "",
          "refId": "A",
          "step": 240
        }
      ],
      "title": "CPU Busy",
      "type": "gauge"
    },
    {
      "datasource": "DS_PROMETHEUS",
      "description": "Busy state of all CPU cores together (5 min average)",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [
            {
              "options": {
                "match": "null",
                "result": {
                  "text": "N/A"
                }
              },
              "type": "special"
            }
          ],
          "max": 100,
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "rgba(50, 172, 45, 0.97)",
                "value": null
              },
              {
                "color": "rgba(237, 129, 40, 0.89)",
                "value": 85
              },
              {
                "color": "rgba(245, 54, 54, 0.9)",
                "value": 95
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 4,
        "w": 4,
        "x": 5,
        "y": 1
      },
      "id": 155,
      "links": [],
      "options": {
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showThresholdLabels": false,
        "showThresholdMarkers": true
      },
      "pluginVersion": "9.5.20",
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "avg(node_load5{instance=\"$node\",job=\"$job\"}) /  count(count(node_cpu_seconds_total{instance=\"$node\",job=\"$job\"}) by (cpu)) * 100",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "refId": "A",
          "step": 240
        }
      ],
      "title": "Sys Load (5m avg)",
      "type": "gauge"
    },
    {
      "datasource": "DS_PROMETHEUS",
      "description": "Busy state of all CPU cores together (15 min average)",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [
            {
              "options": {
                "match": "null",
                "result": {
                  "text": "N/A"
                }
              },
              "type": "special"
            }
          ],
          "max": 100,
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "rgba(50, 172, 45, 0.97)",
                "value": null
              },
              {
                "color": "rgba(237, 129, 40, 0.89)",
                "value": 85
              },
              {
                "color": "rgba(245, 54, 54, 0.9)",
                "value": 95
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 4,
        "w": 4,
        "x": 9,
        "y": 1
      },
      "id": 19,
      "links": [],
      "options": {
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showThresholdLabels": false,
        "showThresholdMarkers": true
      },
      "pluginVersion": "9.5.20",
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "avg(node_load15{instance=\"$node\",job=\"$job\"}) /  count(count(node_cpu_seconds_total{instance=\"$node\",job=\"$job\"}) by (cpu)) * 100",
          "hide": false,
          "intervalFactor": 1,
          "refId": "A",
          "step": 240
        }
      ],
      "title": "Sys Load (15m avg)",
      "type": "gauge"
    },
    {
      "datasource": "DS_PROMETHEUS",
      "description": "Non available RAM memory",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "decimals": 0,
          "mappings": [],
          "max": 100,
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "rgba(50, 172, 45, 0.97)",
                "value": null
              },
              {
                "color": "rgba(237, 129, 40, 0.89)",
                "value": 80
              },
              {
                "color": "rgba(245, 54, 54, 0.9)",
                "value": 90
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 4,
        "w": 5,
        "x": 13,
        "y": 1
      },
      "hideTimeOverride": false,
      "id": 16,
      "links": [],
      "options": {
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showThresholdLabels": false,
        "showThresholdMarkers": true
      },
      "pluginVersion": "9.5.20",
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "((node_memory_MemTotal_bytes{instance=\"$node\",job=\"$job\"} - node_memory_MemFree_bytes{instance=\"$node\",job=\"$job\"}) / (node_memory_MemTotal_bytes{instance=\"$node\",job=\"$job\"} )) * 100",
          "format": "time_series",
          "hide": true,
          "intervalFactor": 1,
          "refId": "A",
          "step": 240
        },
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "100 - ((node_memory_MemAvailable_bytes{instance=\"$node\",job=\"$job\"} * 100) / node_memory_MemTotal_bytes{instance=\"$node\",job=\"$job\"})",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "refId": "B",
          "step": 240
        }
      ],
      "title": "RAM Used",
      "type": "gauge"
    },
    {
      "datasource": "DS_PROMETHEUS",
      "description": "Total number of CPU cores",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [
            {
              "options": {
                "match": "null",
                "result": {
                  "text": "N/A"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 2,
        "w": 2,
        "x": 18,
        "y": 1
      },
      "id": 14,
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "none",
        "graphMode": "none",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "textMode": "auto"
      },
      "pluginVersion": "9.5.20",
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "count(count(node_cpu_seconds_total{instance=\"$node\",job=\"$job\"}) by (cpu))",
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "",
          "refId": "A",
          "step": 240
        }
      ],
      "title": "CPU Cores",
      "type": "stat"
    },
    {
      "datasource": "DS_PROMETHEUS",
      "description": "System uptime",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "decimals": 1,
          "mappings": [
            {
              "options": {
                "match": "null",
                "result": {
                  "text": "N/A"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "s"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 2,
        "w": 4,
        "x": 20,
        "y": 1
      },
      "hideTimeOverride": true,
      "id": 15,
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "none",
        "graphMode": "none",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "textMode": "auto"
      },
      "pluginVersion": "9.5.20",
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "node_time_seconds{instance=\"$node\",job=\"$job\"} - node_boot_time_seconds{instance=\"$node\",job=\"$job\"}",
          "intervalFactor": 2,
          "refId": "A",
          "step": 240
        }
      ],
      "title": "Uptime",
      "type": "stat"
    },
    {
      "datasource": "DS_PROMETHEUS",
      "description": "Total RootFS",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "decimals": 0,
          "mappings": [
            {
              "options": {
                "match": "null",
                "result": {
                  "text": "N/A"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "rgba(50, 172, 45, 0.97)",
                "value": null
              },
              {
                "color": "rgba(237, 129, 40, 0.89)",
                "value": 70
              },
              {
                "color": "rgba(245, 54, 54, 0.9)",
                "value": 90
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 2,
        "w": 2,
        "x": 18,
        "y": 3
      },
      "id": 23,
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "none",
        "graphMode": "none",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "textMode": "auto"
      },
      "pluginVersion": "9.5.20",
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "node_filesystem_size_bytes{instance=\"$node\",job=\"$job\",mountpoint=\"/\",fstype!=\"rootfs\"}",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "refId": "A",
          "step": 240
        }
      ],
      "title": "RootFS Total",
      "type": "stat"
    },
    {
      "datasource": "DS_PROMETHEUS",
      "description": "Total RAM",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "decimals": 0,
          "mappings": [
            {
              "options": {
                "match": "null",
                "result": {
                  "text": "N/A"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 2,
        "w": 2,
        "x": 20,
        "y": 3
      },
      "id": 75,
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "none",
        "graphMode": "none",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "textMode": "auto"
      },
      "pluginVersion": "9.5.20",
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "node_memory_MemTotal_bytes{instance=\"$node\",job=\"$job\"}",
          "intervalFactor": 1,
          "refId": "A",
          "step": 240
        }
      ],
      "title": "RAM Total",
      "type": "stat"
    },
    {
      "datasource": "DS_PROMETHEUS",
      "description": "Total SWAP",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "decimals": 0,
          "mappings": [
            {
              "options": {
                "match": "null",
                "result": {
                  "text": "N/A"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 2,
        "w": 2,
        "x": 22,
        "y": 3
      },
      "id": 18,
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "none",
        "graphMode": "none",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "textMode": "auto"
      },
      "pluginVersion": "9.5.20",
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "node_memory_SwapTotal_bytes{instance=\"$node\",job=\"$job\"}",
          "intervalFactor": 1,
          "refId": "A",
          "step": 240
        }
      ],
      "title": "SWAP Total",
      "type": "stat"
    },
    {
      "collapsed": false,
      "datasource": "DS_PROMETHEUS",
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 5
      },
      "id": 263,
      "panels": [],
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "refId": "A"
        }
      ],
      "title": "Basic CPU / Mem / Net / Disk",
      "type": "row"
    },
    {
      "aliasColors": {
        "Busy": "#EAB839",
        "Busy Iowait": "#890F02",
        "Busy other": "#1F78C1",
        "Idle": "#052B51",
        "Idle - Waiting for something to happen": "#052B51",
        "guest": "#9AC48A",
        "idle": "#052B51",
        "iowait": "#EAB839",
        "irq": "#BF1B00",
        "nice": "#C15C17",
        "softirq": "#E24D42",
        "steal": "#FCE2DE",
        "system": "#508642",
        "user": "#5195CE"
      },
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "DS_PROMETHEUS",
      "decimals": 2,
      "description": "Basic CPU info",
      "fieldConfig": {
        "defaults": {
          "links": []
        },
        "overrides": []
      },
      "fill": 4,
      "fillGradient": 0,
      "gridPos": {
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 6
      },
      "hiddenSeries": false,
      "id": 77,
      "legend": {
        "alignAsTable": false,
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "sideWidth": 250,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "maxPerRow": 6,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": true,
      "pluginVersion": "9.5.20",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [
        {
          "alias": "Busy Iowait",
          "color": "#890F02"
        },
        {
          "alias": "Idle",
          "color": "#7EB26D"
        },
        {
          "alias": "Busy System",
          "color": "#EAB839"
        },
        {
          "alias": "Busy User",
          "color": "#0A437C"
        },
        {
          "alias": "Busy Other",
          "color": "#6D1F62"
        }
      ],
      "spaceLength": 10,
      "stack": true,
      "steppedLine": false,
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "editorMode": "code",
          "expr": "sum by (instance)(rate(node_cpu_seconds_total{mode=\"system\",instance=\"$node\",job=\"$job\", cost_project=\"${cost_project}\"}[$__rate_interval])) * 100",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 2,
          "legendFormat": "Busy System",
          "range": true,
          "refId": "A",
          "step": 240
        },
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "sum by (instance)(rate(node_cpu_seconds_total{mode='user',instance=\"$node\",job=\"$job\"}[$__rate_interval])) * 100",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 2,
          "legendFormat": "Busy User",
          "refId": "B",
          "step": 240
        },
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "sum by (instance)(rate(node_cpu_seconds_total{mode='iowait',instance=\"$node\",job=\"$job\"}[$__rate_interval])) * 100",
          "format": "time_series",
          "intervalFactor": 2,
          "legendFormat": "Busy Iowait",
          "refId": "C",
          "step": 240
        },
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "sum by (instance)(rate(node_cpu_seconds_total{mode=~\".*irq\",instance=\"$node\",job=\"$job\"}[$__rate_interval])) * 100",
          "format": "time_series",
          "intervalFactor": 2,
          "legendFormat": "Busy IRQs",
          "refId": "D",
          "step": 240
        },
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "sum (rate(node_cpu_seconds_total{mode!='idle',mode!='user',mode!='system',mode!='iowait',mode!='irq',mode!='softirq',instance=\"$node\",job=\"$job\"}[$__rate_interval])) * 100",
          "format": "time_series",
          "intervalFactor": 2,
          "legendFormat": "Busy Other",
          "refId": "E",
          "step": 240
        },
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "sum by (mode)(rate(node_cpu_seconds_total{mode='idle',instance=\"$node\",job=\"$job\"}[$__rate_interval])) * 100",
          "format": "time_series",
          "intervalFactor": 2,
          "legendFormat": "Idle",
          "refId": "F",
          "step": 240
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "CPU Basic",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:123",
          "format": "short",
          "label": "",
          "logBase": 1,
          "max": "100",
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:124",
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {
        "Apps": "#629E51",
        "Buffers": "#614D93",
        "Cache": "#6D1F62",
        "Cached": "#511749",
        "Committed": "#508642",
        "Free": "#0A437C",
        "Hardware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
        "Inactive": "#584477",
        "PageTables": "#0A50A1",
        "Page_Tables": "#0A50A1",
        "RAM_Free": "#E0F9D7",
        "SWAP Used": "#BF1B00",
        "Slab": "#806EB7",
        "Slab_Cache": "#E0752D",
        "Swap": "#BF1B00",
        "Swap Used": "#BF1B00",
        "Swap_Cache": "#C15C17",
        "Swap_Free": "#2F575E",
        "Unused": "#EAB839"
      },
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "DS_PROMETHEUS",
      "decimals": 2,
      "description": "Basic memory usage",
      "fieldConfig": {
        "defaults": {
          "links": []
        },
        "overrides": []
      },
      "fill": 4,
      "fillGradient": 0,
      "gridPos": {
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 6
      },
      "hiddenSeries": false,
      "id": 78,
      "legend": {
        "alignAsTable": false,
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "sideWidth": 350,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "maxPerRow": 6,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "9.5.20",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [
        {
          "alias": "RAM Total",
          "color": "#E0F9D7",
          "fill": 0,
          "stack": false
        },
        {
          "alias": "RAM Cache + Buffer",
          "color": "#052B51"
        },
        {
          "alias": "RAM Free",
          "color": "#7EB26D"
        },
        {
          "alias": "Avaliable",
          "color": "#DEDAF7",
          "fill": 0,
          "stack": false
        }
      ],
      "spaceLength": 10,
      "stack": true,
      "steppedLine": false,
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "node_memory_MemTotal_bytes{instance=\"$node\",job=\"$job\"}",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 2,
          "legendFormat": "RAM Total",
          "refId": "A",
          "step": 240
        },
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "node_memory_MemTotal_bytes{instance=\"$node\",job=\"$job\"} - node_memory_MemFree_bytes{instance=\"$node\",job=\"$job\"} - (node_memory_Cached_bytes{instance=\"$node\",job=\"$job\"} + node_memory_Buffers_bytes{instance=\"$node\",job=\"$job\"})",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 2,
          "legendFormat": "RAM Used",
          "refId": "B",
          "step": 240
        },
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "node_memory_Cached_bytes{instance=\"$node\",job=\"$job\"} + node_memory_Buffers_bytes{instance=\"$node\",job=\"$job\"}",
          "format": "time_series",
          "intervalFactor": 2,
          "legendFormat": "RAM Cache + Buffer",
          "refId": "C",
          "step": 240
        },
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "node_memory_MemFree_bytes{instance=\"$node\",job=\"$job\"}",
          "format": "time_series",
          "intervalFactor": 2,
          "legendFormat": "RAM Free",
          "refId": "D",
          "step": 240
        },
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "(node_memory_SwapTotal_bytes{instance=\"$node\",job=\"$job\"} - node_memory_SwapFree_bytes{instance=\"$node\",job=\"$job\"})",
          "format": "time_series",
          "intervalFactor": 2,
          "legendFormat": "SWAP Used",
          "refId": "E",
          "step": 240
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Memory Basic",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "bytes",
          "label": "",
          "logBase": 1,
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {
        "Recv_bytes_eth2": "#7EB26D",
        "Recv_bytes_lo": "#0A50A1",
        "Recv_drop_eth2": "#6ED0E0",
        "Recv_drop_lo": "#E0F9D7",
        "Recv_errs_eth2": "#BF1B00",
        "Recv_errs_lo": "#CCA300",
        "Trans_bytes_eth2": "#7EB26D",
        "Trans_bytes_lo": "#0A50A1",
        "Trans_drop_eth2": "#6ED0E0",
        "Trans_drop_lo": "#E0F9D7",
        "Trans_errs_eth2": "#BF1B00",
        "Trans_errs_lo": "#CCA300",
        "recv_bytes_lo": "#0A50A1",
        "recv_drop_eth0": "#99440A",
        "recv_drop_lo": "#967302",
        "recv_errs_eth0": "#BF1B00",
        "recv_errs_lo": "#890F02",
        "trans_bytes_eth0": "#7EB26D",
        "trans_bytes_lo": "#0A50A1",
        "trans_drop_eth0": "#99440A",
        "trans_drop_lo": "#967302",
        "trans_errs_eth0": "#BF1B00",
        "trans_errs_lo": "#890F02"
      },
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "DS_PROMETHEUS",
      "description": "Basic network info per interface",
      "fieldConfig": {
        "defaults": {
          "links": []
        },
        "overrides": []
      },
      "fill": 4,
      "fillGradient": 0,
      "gridPos": {
        "h": 10,
        "w": 12,
        "x": 0,
        "y": 13
      },
      "hiddenSeries": false,
      "id": 74,
      "legend": {
        "alignAsTable": false,
        "avg": false,
        "current": false,
        "hideEmpty": false,
        "hideZero": false,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "sort": "current",
        "sortDesc": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "9.5.20",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [
        {
          "alias": "/.*trans.*/",
          "transform": "negative-Y"
        }
      ],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "rate(node_network_receive_bytes_total{instance=\"$node\",job=\"$job\"}[$__rate_interval])*8",
          "format": "time_series",
          "intervalFactor": 2,
          "legendFormat": "recv {{device}}",
          "refId": "A",
          "step": 240
        },
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "rate(node_network_transmit_bytes_total{instance=\"$node\",job=\"$job\"}[$__rate_interval])*8",
          "format": "time_series",
          "intervalFactor": 2,
          "legendFormat": "trans {{device}} ",
          "refId": "B",
          "step": 240
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Network Traffic Basic",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "bps",
          "logBase": 1,
          "show": true
        },
        {
          "format": "pps",
          "label": "",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "DS_PROMETHEUS",
      "fieldConfig": {
        "defaults": {
          "links": []
        },
        "overrides": []
      },
      "fill": 2,
      "fillGradient": 0,
      "gridPos": {
        "h": 10,
        "w": 12,
        "x": 12,
        "y": 13
      },
      "hiddenSeries": false,
      "id": 62,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": true,
        "min": true,
        "show": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "maxPerRow": 6,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "9.5.20",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "node_procs_blocked{instance=\"$node\",job=\"$job\"}",
          "format": "time_series",
          "intervalFactor": 2,
          "legendFormat": "Processes blocked waiting for I/O to complete",
          "refId": "A",
          "step": 240
        },
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "node_procs_running{instance=\"$node\",job=\"$job\"}",
          "format": "time_series",
          "intervalFactor": 2,
          "legendFormat": "Processes in runnable state",
          "refId": "B",
          "step": 240
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Processes Status",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:6500",
          "format": "short",
          "label": "counter",
          "logBase": 1,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:6501",
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {
        "receive_packets_eth0": "#7EB26D",
        "receive_packets_lo": "#E24D42",
        "transmit_packets_eth0": "#7EB26D",
        "transmit_packets_lo": "#E24D42"
      },
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "DS_PROMETHEUS",
      "fieldConfig": {
        "defaults": {
          "links": []
        },
        "overrides": []
      },
      "fill": 2,
      "fillGradient": 0,
      "gridPos": {
        "h": 10,
        "w": 12,
        "x": 0,
        "y": 23
      },
      "hiddenSeries": false,
      "id": 60,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": true,
        "min": true,
        "rightSide": false,
        "show": true,
        "sideWidth": 300,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "9.5.20",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [
        {
          "alias": "/.*Trans.*/",
          "transform": "negative-Y"
        }
      ],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "rate(node_network_receive_packets_total{instance=\"$node\",job=\"$job\"}[$__rate_interval])",
          "format": "time_series",
          "interval": "",
          "intervalFactor": 2,
          "legendFormat": "{{device}} - Receive",
          "refId": "A",
          "step": 240
        },
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "rate(node_network_transmit_packets_total{instance=\"$node\",job=\"$job\"}[$__rate_interval])",
          "format": "time_series",
          "interval": "",
          "intervalFactor": 2,
          "legendFormat": "{{device}} - Transmit",
          "refId": "B",
          "step": 240
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Network Traffic by Packets",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "pps",
          "label": "packets out (-) / in (+)",
          "logBase": 1,
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "DS_PROMETHEUS",
      "fieldConfig": {
        "defaults": {
          "links": []
        },
        "overrides": []
      },
      "fill": 2,
      "fillGradient": 0,
      "gridPos": {
        "h": 10,
        "w": 12,
        "x": 12,
        "y": 23
      },
      "hiddenSeries": false,
      "id": 142,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "hideEmpty": false,
        "hideZero": false,
        "max": true,
        "min": true,
        "rightSide": false,
        "show": true,
        "sideWidth": 300,
        "sort": "current",
        "sortDesc": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "9.5.20",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [
        {
          "alias": "/.*Trans.*/",
          "transform": "negative-Y"
        }
      ],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "rate(node_network_receive_errs_total{instance=\"$node\",job=\"$job\"}[$__rate_interval])",
          "format": "time_series",
          "intervalFactor": 2,
          "legendFormat": "{{device}} - Receive errors",
          "refId": "A",
          "step": 240
        },
        {
          "datasource": "DS_PROMETHEUS",
          "expr": "rate(node_network_transmit_errs_total{instance=\"$node\",job=\"$job\"}[$__rate_interval])",
          "format": "time_series",
          "intervalFactor": 2,
          "legendFormat": "{{device}} - Rransmit errors",
          "refId": "B",
          "step": 240
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Network Traffic Errors",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "pps",
          "label": "packets out (-) / in (+)",
          "logBase": 1,
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
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
	},
	"time": {
    "from": "now-24h",
    "to": "now"
  },
  "timepicker": {
    "refresh_intervals": [
      "5s",
      "10s",
      "30s",
      "1m",
      "5m",
      "15m",
      "30m",
      "1h",
      "2h",
      "1d"
    ],
    "time_options": [
      "5m",
      "15m",
      "1h",
      "6h",
      "12h",
      "24h",
      "2d",
      "7d",
      "30d"
    ]
  },
	"timezone": "browser"
}