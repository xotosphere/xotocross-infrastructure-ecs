{
	"editable": true,
	"fiscalYearStartMonth": 0,
	"graphTooltip": 0,
	"links": [],
	"liveNow": false,
	"panels": [
		{
			"collapsed": false,
			"gridPos": {
				"h": 1,
				"w": 24,
				"x": 0,
				"y": 0
			},
			"id": 268,
			"panels": [],
			"title": "Traffic",
			"type": "row"
		},
		{
			"datasource": {
				"type": "loki",
				"uid": "Loki"
			},
			"gridPos": {
				"h": 9,
				"w": 24,
				"x": 0,
				"y": 1
			},
			"id": 264,
			"options": {
				"dedupStrategy": "none",
				"enableLogDetails": true,
				"prettifyLogMessage": false,
				"showCommonLabels": true,
				"showLabels": false,
				"showTime": false,
				"sortOrder": "Descending",
				"wrapLogMessage": false
			},
			"targets": [
				{
					"datasource": {
						"type": "loki",
						"uid": "Loki"
					},
					"editorMode": "builder",
					"expr": "{cost_project=\"${cost_project}\", container=\"xotocross-${cost_project}-frontend\"} | line_format `{{.log}}`",
					"queryType": "range",
					"refId": "A"
				}
			],
			"title": "Cross App Logs ${cost_project} frontend",
			"transformations": [],
			"transparent": true,
			"type": "logs"
		},
		{
			"datasource": {
				"type": "loki",
				"uid": "Loki"
			},
			"gridPos": {
				"h": 9,
				"w": 24,
				"x": 0,
				"y": 10
			},
			"id": 275,
			"options": {
				"dedupStrategy": "none",
				"enableLogDetails": true,
				"prettifyLogMessage": false,
				"showCommonLabels": true,
				"showLabels": false,
				"showTime": false,
				"sortOrder": "Descending",
				"wrapLogMessage": false
			},
			"targets": [
				{
					"datasource": {
						"type": "loki",
						"uid": "Loki"
					},
					"editorMode": "builder",
					"expr": "{cost_project=\"${cost_project}\", container=\"xotocross-${cost_project}-backend\"} | line_format `{{.log}}`",
					"queryType": "range",
					"refId": "A"
				}
			],
			"title": "Cross App Logs ${cost_project} backend",
			"transformations": [],
			"transparent": true,
			"type": "logs"
		},
		{
			"collapsed": false,
			"gridPos": {
				"h": 1,
				"w": 24,
				"x": 0,
				"y": 19
			},
			"id": 269,
			"panels": [],
			"title": "Error",
			"type": "row"
		},
		{
			"datasource": {
				"type": "loki",
				"uid": "Loki"
			},
			"gridPos": {
				"h": 7,
				"w": 24,
				"x": 0,
				"y": 20
			},
			"id": 265,
			"options": {
				"dedupStrategy": "none",
				"enableLogDetails": true,
				"prettifyLogMessage": false,
				"showCommonLabels": true,
				"showLabels": false,
				"showTime": false,
				"sortOrder": "Descending",
				"wrapLogMessage": false
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "loki",
						"uid": "Loki"
					},
					"editorMode": "builder",
					"expr": "{cost_project=\"${cost_project}\", status_code=~\"4.*|5.*\"} | line_format `{{.log}}`",
					"queryType": "range",
					"refId": "A"
				}
			],
			"title": "Cross App Error Spot",
			"transparent": true,
			"type": "logs"
		},
		{
			"datasource": {
				"type": "loki",
				"uid": "Loki"
			},
			"fieldConfig": {
				"defaults": {
					"color": {
						"mode": "palette-classic"
					},
					"custom": {
						"hideFrom": {
							"legend": false,
							"tooltip": false,
							"viz": false
						}
					},
					"displayName": "${__field.labels.method}",
					"mappings": []
				},
				"overrides": []
			},
			"gridPos": {
				"h": 7,
				"w": 6,
				"x": 0,
				"y": 27
			},
			"id": 272,
			"options": {
				"legend": {
					"displayMode": "list",
					"placement": "bottom",
					"showLegend": true,
					"values": []
				},
				"pieType": "pie",
				"reduceOptions": {
					"calcs": ["lastNotNull"],
					"fields": "",
					"values": false
				},
				"tooltip": {
					"mode": "single",
					"sort": "none"
				}
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "loki",
						"uid": "Loki"
					},
					"editorMode": "code",
					"expr": "sum by(method) (rate({cost_project=\"${cost_project}\", method=~\"GET\"} [$__interval]))",
					"queryType": "range",
					"refId": "A"
				}
			],
			"title": "Cross App Distribution Receive",
			"transformations": [],
			"transparent": true,
			"type": "piechart"
		},
		{
			"datasource": {
				"type": "loki",
				"uid": "Loki"
			},
			"fieldConfig": {
				"defaults": {
					"color": {
						"mode": "palette-classic"
					},
					"custom": {
						"hideFrom": {
							"legend": false,
							"tooltip": false,
							"viz": false
						}
					},
					"displayName": "${__field.labels.method}",
					"mappings": []
				},
				"overrides": []
			},
			"gridPos": {
				"h": 7,
				"w": 6,
				"x": 6,
				"y": 27
			},
			"id": 267,
			"options": {
				"legend": {
					"displayMode": "list",
					"placement": "bottom",
					"showLegend": true
				},
				"pieType": "pie",
				"reduceOptions": {
					"calcs": ["lastNotNull"],
					"fields": "",
					"values": false
				},
				"tooltip": {
					"mode": "single",
					"sort": "none"
				}
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "loki",
						"uid": "Loki"
					},
					"editorMode": "builder",
					"expr": "sum by(method) (rate({cost_project=\"${cost_project}\", method=~\"POST|PUT|PATCH|DELETE\"} [$__interval]))",
					"queryType": "range",
					"refId": "A"
				}
			],
			"title": "Cross App Distribution Send",
			"transformations": [],
			"transparent": true,
			"type": "piechart"
		},
		{
			"datasource": {
				"type": "loki",
				"uid": "Loki"
			},
			"fieldConfig": {
				"defaults": {
					"color": {
						"mode": "thresholds"
					},
					"mappings": [],
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
					}
				},
				"overrides": []
			},
			"gridPos": {
				"h": 7,
				"w": 6,
				"x": 12,
				"y": 27
			},
			"id": 274,
			"options": {
				"colorMode": "value",
				"graphMode": "area",
				"justifyMode": "auto",
				"orientation": "auto",
				"reduceOptions": {
					"calcs": ["count"],
					"fields": "/^id$/",
					"values": false
				},
				"textMode": "auto"
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "loki",
						"uid": "Loki"
					},
					"editorMode": "code",
					"expr": "{cost_project=\"${cost_project}\", status_code=~\"2.*\"}",
					"queryType": "range",
					"refId": "A"
				}
			],
			"title": "Cross App Client 200s Success",
			"transformations": [],
			"transparent": true,
			"type": "stat"
		},
		{
			"datasource": {
				"type": "loki",
				"uid": "Loki"
			},
			"fieldConfig": {
				"defaults": {
					"color": {
						"mode": "thresholds"
					},
					"custom": {
						"neutral": -1
					},
					"mappings": [],
					"thresholds": {
						"mode": "absolute",
						"steps": [
							{
								"color": "green",
								"value": null
							},
							{
								"color": "#EAB839",
								"value": 80
							},
							{
								"color": "red",
								"value": 100
							}
						]
					}
				},
				"overrides": []
			},
			"gridPos": {
				"h": 7,
				"w": 6,
				"x": 18,
				"y": 27
			},
			"id": 273,
			"options": {
				"orientation": "auto",
				"reduceOptions": {
					"calcs": ["count"],
					"fields": "/^labels$/",
					"values": false
				},
				"showThresholdLabels": true,
				"showThresholdMarkers": true
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "loki",
						"uid": "Loki"
					},
					"editorMode": "code",
					"expr": "{cost_project=\"${cost_project}\", status_code=~\"3.*\"}",
					"queryType": "range",
					"refId": "A"
				}
			],
			"title": "Cross App Client 300s Error",
			"transformations": [],
			"transparent": true,
			"type": "gauge"
		},
		{
			"datasource": {
				"type": "prometheus",
				"uid": "Prometheus"
			},
			"fieldConfig": {
				"defaults": {
					"color": {
						"mode": "palette-classic"
					},
					"custom": {
						"axisCenteredZero": false,
						"axisColorMode": "text",
						"axisLabel": "packets out (-) / in (+)",
						"axisPlacement": "auto",
						"barAlignment": 0,
						"drawStyle": "line",
						"fillOpacity": 16,
						"gradientMode": "none",
						"hideFrom": {
							"legend": false,
							"tooltip": false,
							"viz": false
						},
						"lineInterpolation": "smooth",
						"lineWidth": 3,
						"pointSize": 5,
						"scaleDistribution": {
							"type": "linear"
						},
						"showPoints": "never",
						"spanNulls": false,
						"stacking": {
							"group": "A",
							"mode": "none"
						},
						"thresholdsStyle": {
							"mode": "off"
						}
					},
					"links": [],
					"mappings": [],
					"thresholds": {
						"mode": "absolute",
						"steps": [
							{
								"color": "green",
								"value": null
							},
							{
								"color": "red",
								"value": 1
							}
						]
					},
					"unit": "pps"
				},
				"overrides": [
					{
						"matcher": {
							"id": "byRegexp",
							"options": "/.*Trans.*/"
						},
						"properties": [
							{
								"id": "custom.transform",
								"value": "negative-Y"
							}
						]
					}
				]
			},
			"gridPos": {
				"h": 7,
				"w": 12,
				"x": 0,
				"y": 34
			},
			"id": 142,
			"links": [],
			"options": {
				"legend": {
					"calcs": ["mean", "lastNotNull", "max", "min"],
					"displayMode": "table",
					"placement": "bottom",
					"showLegend": true,
					"width": 300
				},
				"tooltip": {
					"mode": "multi",
					"sort": "none"
				}
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "rate(node_network_receive_errs_total{instance=\"$node\",job=\"$job\"}[$__rate_interval])",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "{{device}} - Receive errors",
					"refId": "A",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "rate(node_network_transmit_errs_total{instance=\"$node\",job=\"$job\"}[$__rate_interval])",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "{{device}} - Rransmit errors",
					"refId": "B",
					"step": 240
				}
			],
			"title": "Cross Cluster Network Traffic Errors",
			"transparent": true,
			"type": "timeseries"
		},
		{
			"datasource": {
				"type": "loki",
				"uid": "Loki"
			},
			"fieldConfig": {
				"defaults": {
					"color": {
						"mode": "thresholds"
					},
					"custom": {
						"neutral": -1
					},
					"mappings": [],
					"thresholds": {
						"mode": "absolute",
						"steps": [
							{
								"color": "green",
								"value": null
							},
							{
								"color": "#EAB839",
								"value": 80
							},
							{
								"color": "red",
								"value": 100
							}
						]
					}
				},
				"overrides": []
			},
			"gridPos": {
				"h": 7,
				"w": 6,
				"x": 12,
				"y": 34
			},
			"id": 271,
			"options": {
				"orientation": "auto",
				"reduceOptions": {
					"calcs": ["count"],
					"fields": "/^labels$/",
					"values": false
				},
				"showThresholdLabels": true,
				"showThresholdMarkers": true,
				"text": {}
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "loki",
						"uid": "Loki"
					},
					"editorMode": "code",
					"expr": "{cost_project=\"${cost_project}\", status_code=~\"4.*\"}",
					"queryType": "range",
					"refId": "A"
				}
			],
			"title": "Cross App Client 400s Error",
			"transformations": [],
			"transparent": true,
			"type": "gauge"
		},
		{
			"datasource": {
				"type": "loki",
				"uid": "Loki"
			},
			"fieldConfig": {
				"defaults": {
					"color": {
						"mode": "thresholds"
					},
					"custom": {
						"neutral": -1
					},
					"mappings": [],
					"thresholds": {
						"mode": "absolute",
						"steps": [
							{
								"color": "green",
								"value": null
							},
							{
								"color": "#EAB839",
								"value": 80
							},
							{
								"color": "red",
								"value": 100
							}
						]
					}
				},
				"overrides": []
			},
			"gridPos": {
				"h": 7,
				"w": 6,
				"x": 18,
				"y": 34
			},
			"id": 266,
			"options": {
				"orientation": "auto",
				"reduceOptions": {
					"calcs": ["count"],
					"fields": "/^labels$/",
					"values": false
				},
				"showThresholdLabels": true,
				"showThresholdMarkers": true
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "loki",
						"uid": "Loki"
					},
					"editorMode": "code",
					"expr": "{cost_project=\"${cost_project}\", status_code=~\"5.*\"}",
					"queryType": "range",
					"refId": "A"
				}
			],
			"title": "Cross App 500s Error",
			"transformations": [],
			"transparent": true,
			"type": "gauge"
		},
		{
			"collapsed": false,
			"datasource": {
				"type": "prometheus",
				"uid": "Prometheus"
			},
			"gridPos": {
				"h": 1,
				"w": 24,
				"x": 0,
				"y": 41
			},
			"id": 261,
			"panels": [],
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"refId": "A"
				}
			],
			"title": "Cluster",
			"type": "row"
		},
		{
			"datasource": {
				"type": "prometheus",
				"uid": "Prometheus"
			},
			"fieldConfig": {
				"defaults": {
					"color": {
						"mode": "palette-classic"
					},
					"custom": {
						"axisCenteredZero": false,
						"axisColorMode": "text",
						"axisLabel": "counter",
						"axisPlacement": "auto",
						"barAlignment": 0,
						"drawStyle": "line",
						"fillOpacity": 11,
						"gradientMode": "none",
						"hideFrom": {
							"legend": false,
							"tooltip": false,
							"viz": false
						},
						"lineInterpolation": "smooth",
						"lineWidth": 2,
						"pointSize": 5,
						"scaleDistribution": {
							"type": "linear"
						},
						"showPoints": "never",
						"spanNulls": false,
						"stacking": {
							"group": "A",
							"mode": "none"
						},
						"thresholdsStyle": {
							"mode": "off"
						}
					},
					"links": [],
					"mappings": [],
					"min": 0,
					"thresholds": {
						"mode": "absolute",
						"steps": [
							{
								"color": "green",
								"value": null
							},
							{
								"color": "#EAB839",
								"value": 8
							},
							{
								"color": "red",
								"value": 10
							}
						]
					},
					"unit": "short"
				},
				"overrides": []
			},
			"gridPos": {
				"h": 7,
				"w": 24,
				"x": 0,
				"y": 42
			},
			"id": 62,
			"links": [],
			"options": {
				"legend": {
					"calcs": ["mean", "lastNotNull", "max", "min"],
					"displayMode": "table",
					"placement": "bottom",
					"showLegend": true
				},
				"tooltip": {
					"mode": "multi",
					"sort": "none"
				}
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "node_procs_blocked{instance=\"$node\",job=\"$job\"}",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "Processes blocked waiting for I/O to complete",
					"refId": "A",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "node_procs_running{instance=\"$node\",job=\"$job\"}",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "Processes in runnable state",
					"refId": "B",
					"step": 240
				}
			],
			"title": "Cross Cluster Processes Status",
			"transparent": true,
			"type": "timeseries"
		},
		{
			"datasource": {
				"type": "prometheus",
				"uid": "Prometheus"
			},
			"fieldConfig": {
				"defaults": {
					"color": {
						"mode": "palette-classic"
					},
					"custom": {
						"axisCenteredZero": false,
						"axisColorMode": "text",
						"axisLabel": "packets out (-) / in (+)",
						"axisPlacement": "auto",
						"barAlignment": 0,
						"drawStyle": "line",
						"fillOpacity": 10,
						"gradientMode": "none",
						"hideFrom": {
							"legend": false,
							"tooltip": false,
							"viz": false
						},
						"lineInterpolation": "smooth",
						"lineWidth": 2,
						"pointSize": 5,
						"scaleDistribution": {
							"type": "linear"
						},
						"showPoints": "never",
						"spanNulls": false,
						"stacking": {
							"group": "A",
							"mode": "none"
						},
						"thresholdsStyle": {
							"mode": "off"
						}
					},
					"links": [],
					"mappings": [],
					"thresholds": {
						"mode": "absolute",
						"steps": [
							{
								"color": "green",
								"value": null
							},
							{
								"color": "orange",
								"value": 8
							},
							{
								"color": "red",
								"value": 10
							}
						]
					},
					"unit": "pps"
				},
				"overrides": [
					{
						"matcher": {
							"id": "byName",
							"options": "receive_packets_eth0"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#7EB26D",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "receive_packets_lo"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#E24D42",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "transmit_packets_eth0"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#7EB26D",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "transmit_packets_lo"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#E24D42",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byRegexp",
							"options": "/.*Trans.*/"
						},
						"properties": [
							{
								"id": "custom.transform",
								"value": "negative-Y"
							}
						]
					}
				]
			},
			"gridPos": {
				"h": 7,
				"w": 12,
				"x": 0,
				"y": 49
			},
			"id": 60,
			"links": [],
			"options": {
				"legend": {
					"calcs": ["mean", "lastNotNull", "max", "min"],
					"displayMode": "table",
					"placement": "bottom",
					"showLegend": true,
					"width": 300
				},
				"tooltip": {
					"mode": "multi",
					"sort": "none"
				}
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "rate(node_network_receive_packets_total{instance=\"$node\",job=\"$job\"}[$__rate_interval])",
					"format": "time_series",
					"interval": "",
					"intervalFactor": 2,
					"legendFormat": "{{device}} - Receive",
					"refId": "A",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "rate(node_network_transmit_packets_total{instance=\"$node\",job=\"$job\"}[$__rate_interval])",
					"format": "time_series",
					"interval": "",
					"intervalFactor": 2,
					"legendFormat": "{{device}} - Transmit",
					"refId": "B",
					"step": 240
				}
			],
			"title": "Cross Cluster Network Traffic by Packets",
			"transparent": true,
			"type": "timeseries"
		},
		{
			"datasource": {
				"type": "prometheus",
				"uid": "Prometheus"
			},
			"description": "xotocross basic network info per interface",
			"fieldConfig": {
				"defaults": {
					"color": {
						"mode": "palette-classic"
					},
					"custom": {
						"axisCenteredZero": false,
						"axisColorMode": "text",
						"axisLabel": "",
						"axisPlacement": "auto",
						"barAlignment": 0,
						"drawStyle": "line",
						"fillOpacity": 10,
						"gradientMode": "none",
						"hideFrom": {
							"legend": false,
							"tooltip": false,
							"viz": false
						},
						"lineInterpolation": "smooth",
						"lineWidth": 2,
						"pointSize": 5,
						"scaleDistribution": {
							"type": "linear"
						},
						"showPoints": "never",
						"spanNulls": false,
						"stacking": {
							"group": "A",
							"mode": "none"
						},
						"thresholdsStyle": {
							"mode": "off"
						}
					},
					"links": [],
					"mappings": [],
					"thresholds": {
						"mode": "absolute",
						"steps": [
							{
								"color": "green",
								"value": null
							},
							{
								"color": "orange",
								"value": 10
							},
							{
								"color": "red",
								"value": 15
							}
						]
					},
					"unit": "bps"
				},
				"overrides": [
					{
						"matcher": {
							"id": "byName",
							"options": "Recv_bytes_eth2"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#7EB26D",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Recv_bytes_lo"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#0A50A1",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Recv_drop_eth2"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#6ED0E0",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Recv_drop_lo"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#E0F9D7",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Recv_errs_eth2"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#BF1B00",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Recv_errs_lo"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#CCA300",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Trans_bytes_eth2"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#7EB26D",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Trans_bytes_lo"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#0A50A1",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Trans_drop_eth2"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#6ED0E0",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Trans_drop_lo"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#E0F9D7",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Trans_errs_eth2"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#BF1B00",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Trans_errs_lo"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#CCA300",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "recv_bytes_lo"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#0A50A1",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "recv_drop_eth0"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#99440A",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "recv_drop_lo"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#967302",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "recv_errs_eth0"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#BF1B00",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "recv_errs_lo"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#890F02",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "trans_bytes_eth0"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#7EB26D",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "trans_bytes_lo"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#0A50A1",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "trans_drop_eth0"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#99440A",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "trans_drop_lo"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#967302",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "trans_errs_eth0"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#BF1B00",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "trans_errs_lo"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#890F02",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byRegexp",
							"options": "/.*trans.*/"
						},
						"properties": [
							{
								"id": "custom.transform",
								"value": "negative-Y"
							}
						]
					}
				]
			},
			"gridPos": {
				"h": 7,
				"w": 12,
				"x": 12,
				"y": 49
			},
			"id": 74,
			"links": [],
			"options": {
				"legend": {
					"calcs": [],
					"displayMode": "list",
					"placement": "bottom",
					"showLegend": true
				},
				"tooltip": {
					"mode": "multi",
					"sort": "none"
				}
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "rate(node_network_receive_bytes_total{instance=\"$node\",job=\"$job\"}[$__rate_interval])*8",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "recv {{device}}",
					"refId": "A",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "rate(node_network_transmit_bytes_total{instance=\"$node\",job=\"$job\"}[$__rate_interval])*8",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "trans {{device}} ",
					"refId": "B",
					"step": 240
				}
			],
			"title": "Cross Cluster Network Traffic",
			"transparent": true,
			"type": "timeseries"
		},
		{
			"datasource": {
				"type": "prometheus",
				"uid": "Prometheus"
			},
			"description": "xotocross basic memory usage",
			"fieldConfig": {
				"defaults": {
					"color": {
						"mode": "palette-classic"
					},
					"custom": {
						"hideFrom": {
							"legend": false,
							"tooltip": false,
							"viz": false
						}
					},
					"links": [],
					"mappings": [],
					"min": 0,
					"unit": "bytes"
				},
				"overrides": [
					{
						"matcher": {
							"id": "byName",
							"options": "Apps"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#629E51",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Buffers"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#614D93",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Cache"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#6D1F62",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Cached"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#511749",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Committed"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#508642",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Free"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#0A437C",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Hardware Corrupted - Amount of RAM that the kernel identified as corrupted / not working"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#CFFAFF",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Inactive"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#584477",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "PageTables"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#0A50A1",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Page_Tables"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#0A50A1",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "RAM_Free"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#E0F9D7",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "SWAP Used"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#BF1B00",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Slab"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#806EB7",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Slab_Cache"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#E0752D",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Swap"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#BF1B00",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Swap Used"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#BF1B00",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Swap_Cache"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#C15C17",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Swap_Free"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#2F575E",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Unused"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#EAB839",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "RAM Total"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#E0F9D7",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "RAM Cache + Buffer"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#052B51",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "RAM Free"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#7EB26D",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Avaliable"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#DEDAF7",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"__systemRef": "hideSeriesFrom",
						"matcher": {
							"id": "byNames",
							"options": {
								"mode": "exclude",
								"names": ["RAM Used", "RAM Free"],
								"prefix": "All except:",
								"readOnly": true
							}
						},
						"properties": [
							{
								"id": "custom.hideFrom",
								"value": {
									"legend": false,
									"tooltip": false,
									"viz": true
								}
							}
						]
					}
				]
			},
			"gridPos": {
				"h": 10,
				"w": 12,
				"x": 0,
				"y": 56
			},
			"id": 270,
			"links": [],
			"options": {
				"displayLabels": ["percent"],
				"legend": {
					"displayMode": "table",
					"placement": "right",
					"showLegend": true,
					"values": ["value"]
				},
				"pieType": "pie",
				"reduceOptions": {
					"calcs": ["lastNotNull"],
					"fields": "",
					"values": false
				},
				"tooltip": {
					"mode": "single",
					"sort": "none"
				}
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "node_memory_MemTotal_bytes{instance=\"$node\",job=\"$job\"}",
					"format": "time_series",
					"hide": false,
					"intervalFactor": 2,
					"legendFormat": "RAM Total",
					"refId": "A",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "node_memory_MemTotal_bytes{instance=\"$node\",job=\"$job\"} - node_memory_MemFree_bytes{instance=\"$node\",job=\"$job\"} - (node_memory_Cached_bytes{instance=\"$node\",job=\"$job\"} + node_memory_Buffers_bytes{instance=\"$node\",job=\"$job\"})",
					"format": "time_series",
					"hide": false,
					"intervalFactor": 2,
					"legendFormat": "RAM Used",
					"refId": "B",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "node_memory_Cached_bytes{instance=\"$node\",job=\"$job\"} + node_memory_Buffers_bytes{instance=\"$node\",job=\"$job\"}",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "RAM Cache + Buffer",
					"refId": "C",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "node_memory_MemFree_bytes{instance=\"$node\",job=\"$job\"}",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "RAM Free",
					"refId": "D",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "(node_memory_SwapTotal_bytes{instance=\"$node\",job=\"$job\"} - node_memory_SwapFree_bytes{instance=\"$node\",job=\"$job\"})",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "SWAP Used",
					"refId": "E",
					"step": 240
				}
			],
			"title": "Cross Cluster Memory",
			"transparent": true,
			"type": "piechart"
		},
		{
			"datasource": {
				"type": "prometheus",
				"uid": "Prometheus"
			},
			"description": "xotocross total number of cpu cores",
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
								"value": 0
							},
							{
								"color": "#EAB839",
								"value": 1
							},
							{
								"color": "green",
								"value": 2
							}
						]
					},
					"unit": "short"
				},
				"overrides": []
			},
			"gridPos": {
				"h": 5,
				"w": 6,
				"x": 12,
				"y": 56
			},
			"id": 14,
			"links": [],
			"maxDataPoints": 100,
			"options": {
				"colorMode": "background",
				"graphMode": "none",
				"justifyMode": "auto",
				"orientation": "horizontal",
				"reduceOptions": {
					"calcs": ["lastNotNull"],
					"fields": "",
					"values": false
				},
				"textMode": "auto"
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "count(count(node_cpu_seconds_total{instance=\"$node\",job=\"$job\"}) by (cpu))",
					"interval": "",
					"intervalFactor": 1,
					"legendFormat": "",
					"refId": "A",
					"step": 240
				}
			],
			"title": "Cross Cluster CPU Cores",
			"transparent": true,
			"type": "stat"
		},
		{
			"datasource": {
				"type": "prometheus",
				"uid": "Prometheus"
			},
			"description": "xotocross system uptime",
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
								"value": 0
							},
							{
								"color": "#EAB839",
								"value": 1
							},
							{
								"color": "green",
								"value": 3
							}
						]
					},
					"unit": "s"
				},
				"overrides": []
			},
			"gridPos": {
				"h": 10,
				"w": 6,
				"x": 18,
				"y": 56
			},
			"hideTimeOverride": true,
			"id": 15,
			"links": [],
			"maxDataPoints": 100,
			"options": {
				"colorMode": "background",
				"graphMode": "none",
				"justifyMode": "auto",
				"orientation": "horizontal",
				"reduceOptions": {
					"calcs": ["lastNotNull"],
					"fields": "",
					"values": false
				},
				"textMode": "auto"
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "node_time_seconds{instance=\"$node\",job=\"$job\"} - node_boot_time_seconds{instance=\"$node\",job=\"$job\"}",
					"intervalFactor": 2,
					"refId": "A",
					"step": 240
				}
			],
			"title": "Cross Cluster Uptime",
			"transparent": true,
			"type": "stat"
		},
		{
			"datasource": {
				"type": "prometheus",
				"uid": "Prometheus"
			},
			"description": "xotocross total ram",
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
								"value": 1
							},
							{
								"color": "#EAB839",
								"value": 2
							},
							{
								"color": "green",
								"value": 4
							}
						]
					},
					"unit": "bytes"
				},
				"overrides": []
			},
			"gridPos": {
				"h": 5,
				"w": 6,
				"x": 12,
				"y": 61
			},
			"id": 75,
			"links": [],
			"maxDataPoints": 100,
			"options": {
				"colorMode": "background",
				"graphMode": "none",
				"justifyMode": "auto",
				"orientation": "horizontal",
				"reduceOptions": {
					"calcs": ["lastNotNull"],
					"fields": "",
					"values": false
				},
				"textMode": "auto"
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "node_memory_MemTotal_bytes{instance=\"$node\",job=\"$job\"}",
					"intervalFactor": 1,
					"refId": "A",
					"step": 240
				}
			],
			"title": "Cross Cluster RAM Total",
			"transparent": true,
			"type": "stat"
		},
		{
			"datasource": {
				"type": "prometheus",
				"uid": "PBFA97CFB590B2093"
			},
			"description": "xotocross basic memory usage",
			"fieldConfig": {
				"defaults": {
					"color": {
						"mode": "thresholds"
					},
					"links": [],
					"mappings": [],
					"min": 0,
					"thresholds": {
						"mode": "absolute",
						"steps": [
							{
								"color": "green",
								"value": null
							}
						]
					},
					"unit": "bytes"
				},
				"overrides": [
					{
						"matcher": {
							"id": "byName",
							"options": "Apps"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#629E51",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Buffers"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#614D93",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Cache"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#6D1F62",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Cached"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#511749",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Committed"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#508642",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Free"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#0A437C",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Hardware Corrupted - Amount of RAM that the kernel identified as corrupted / not working"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#CFFAFF",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Inactive"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#584477",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "PageTables"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#0A50A1",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Page_Tables"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#0A50A1",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "RAM_Free"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#E0F9D7",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "SWAP Used"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#BF1B00",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Slab"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#806EB7",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Slab_Cache"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#E0752D",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Swap"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#BF1B00",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Swap Used"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#BF1B00",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Swap_Cache"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#C15C17",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Swap_Free"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#2F575E",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Unused"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#EAB839",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "RAM Total"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#E0F9D7",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "RAM Cache + Buffer"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#052B51",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "RAM Free"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#7EB26D",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Avaliable"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#DEDAF7",
									"mode": "fixed"
								}
							}
						]
					}
				]
			},
			"gridPos": {
				"h": 10,
				"w": 6,
				"x": 0,
				"y": 66
			},
			"id": 78,
			"links": [],
			"options": {
				"orientation": "auto",
				"reduceOptions": {
					"calcs": ["lastNotNull"],
					"fields": "",
					"values": false
				},
				"showThresholdLabels": false,
				"showThresholdMarkers": true
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "node_memory_MemTotal_bytes{instance=\"$node\",job=\"$job\"}",
					"format": "time_series",
					"hide": false,
					"intervalFactor": 2,
					"legendFormat": "RAM Total",
					"refId": "A",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "node_memory_MemTotal_bytes{instance=\"$node\",job=\"$job\"} - node_memory_MemFree_bytes{instance=\"$node\",job=\"$job\"} - (node_memory_Cached_bytes{instance=\"$node\",job=\"$job\"} + node_memory_Buffers_bytes{instance=\"$node\",job=\"$job\"})",
					"format": "time_series",
					"hide": false,
					"intervalFactor": 2,
					"legendFormat": "RAM Used",
					"refId": "B",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "node_memory_Cached_bytes{instance=\"$node\",job=\"$job\"} + node_memory_Buffers_bytes{instance=\"$node\",job=\"$job\"}",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "RAM Cache + Buffer",
					"refId": "C",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "node_memory_MemFree_bytes{instance=\"$node\",job=\"$job\"}",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "RAM Free",
					"refId": "D",
					"step": 240
				}
			],
			"title": "Cross Cluster Memory",
			"transparent": true,
			"type": "gauge"
		},
		{
			"datasource": {
				"type": "prometheus",
				"uid": "Prometheus"
			},
			"description": "xotocross busy state of all cpu cores together",
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
				"h": 5,
				"w": 3,
				"x": 6,
				"y": 66
			},
			"id": 20,
			"links": [],
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
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "(((count(count(node_cpu_seconds_total{instance=\"$node\",job=\"$job\"}) by (cpu))) - avg(sum by (mode)(rate(node_cpu_seconds_total{mode='idle',instance=\"$node\",job=\"$job\"}[$__rate_interval])))) * 100) / count(count(node_cpu_seconds_total{instance=\"$node\",job=\"$job\"}) by (cpu))",
					"hide": false,
					"intervalFactor": 1,
					"legendFormat": "",
					"refId": "A",
					"step": 240
				}
			],
			"title": "Cross Cluster CPU",
			"transparent": true,
			"type": "gauge"
		},
		{
			"datasource": {
				"type": "prometheus",
				"uid": "Prometheus"
			},
			"description": "xotocross busy state of all cpu cores together (5 min average)",
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
				"h": 5,
				"w": 3,
				"x": 9,
				"y": 66
			},
			"id": 155,
			"links": [],
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
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "avg(node_load5{instance=\"$node\",job=\"$job\"}) /  count(count(node_cpu_seconds_total{instance=\"$node\",job=\"$job\"}) by (cpu)) * 100",
					"format": "time_series",
					"hide": false,
					"intervalFactor": 1,
					"refId": "A",
					"step": 240
				}
			],
			"title": "Cross Cluster System Load (5m avg)",
			"transparent": true,
			"type": "gauge"
		},
		{
			"datasource": {
				"type": "prometheus",
				"uid": "Prometheus"
			},
			"description": "xotocross basic cpu info",
			"fieldConfig": {
				"defaults": {
					"color": {
						"mode": "palette-classic"
					},
					"custom": {
						"axisCenteredZero": false,
						"axisColorMode": "text",
						"axisLabel": "",
						"axisPlacement": "auto",
						"barAlignment": 0,
						"drawStyle": "line",
						"fillOpacity": 9,
						"gradientMode": "none",
						"hideFrom": {
							"legend": false,
							"tooltip": false,
							"viz": false
						},
						"lineInterpolation": "smooth",
						"lineWidth": 1,
						"pointSize": 5,
						"scaleDistribution": {
							"type": "linear"
						},
						"showPoints": "never",
						"spanNulls": false,
						"stacking": {
							"group": "A",
							"mode": "normal"
						},
						"thresholdsStyle": {
							"mode": "off"
						}
					},
					"links": [],
					"mappings": [],
					"max": 53,
					"min": 0,
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
				"overrides": [
					{
						"matcher": {
							"id": "byName",
							"options": "Busy"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#EAB839",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Busy Iowait"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#890F02",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Busy other"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#1F78C1",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Idle"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#052B51",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Idle - Waiting for something to happen"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#052B51",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "guest"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#9AC48A",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "idle"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#052B51",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "iowait"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#EAB839",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "irq"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#BF1B00",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "nice"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#C15C17",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "softirq"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#E24D42",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "steal"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#FCE2DE",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "system"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#508642",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "user"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#5195CE",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Busy Iowait"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#890F02",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Idle"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#7EB26D",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Busy System"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#EAB839",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Busy User"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#0A437C",
									"mode": "fixed"
								}
							}
						]
					},
					{
						"matcher": {
							"id": "byName",
							"options": "Busy Other"
						},
						"properties": [
							{
								"id": "color",
								"value": {
									"fixedColor": "#6D1F62",
									"mode": "fixed"
								}
							}
						]
					}
				]
			},
			"gridPos": {
				"h": 10,
				"w": 12,
				"x": 12,
				"y": 66
			},
			"id": 77,
			"links": [],
			"options": {
				"legend": {
					"calcs": [],
					"displayMode": "list",
					"placement": "bottom",
					"showLegend": true,
					"width": 250
				},
				"tooltip": {
					"mode": "multi",
					"sort": "none"
				}
			},
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
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
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "sum by (instance)(rate(node_cpu_seconds_total{mode='user',instance=\"$node\",job=\"$job\"}[$__rate_interval])) * 100",
					"format": "time_series",
					"hide": false,
					"intervalFactor": 2,
					"legendFormat": "Busy User",
					"refId": "B",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "sum by (instance)(rate(node_cpu_seconds_total{mode='iowait',instance=\"$node\",job=\"$job\"}[$__rate_interval])) * 100",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "Busy Iowait",
					"refId": "C",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "sum by (instance)(rate(node_cpu_seconds_total{mode=~\".*irq\",instance=\"$node\",job=\"$job\"}[$__rate_interval])) * 100",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "Busy IRQs",
					"refId": "D",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "sum (rate(node_cpu_seconds_total{mode!='idle',mode!='user',mode!='system',mode!='iowait',mode!='irq',mode!='softirq',instance=\"$node\",job=\"$job\"}[$__rate_interval])) * 100",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "Busy Other",
					"refId": "E",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "sum by (mode)(rate(node_cpu_seconds_total{mode='idle',instance=\"$node\",job=\"$job\"}[$__rate_interval])) * 100",
					"format": "time_series",
					"intervalFactor": 2,
					"legendFormat": "Idle",
					"refId": "F",
					"step": 240
				}
			],
			"title": "Cross Cluster CPU",
			"transparent": true,
			"type": "timeseries"
		},
		{
			"datasource": {
				"type": "prometheus",
				"uid": "Prometheus"
			},
			"description": "xotocross non available ram memory",
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
				"h": 5,
				"w": 3,
				"x": 6,
				"y": 71
			},
			"hideTimeOverride": false,
			"id": 16,
			"links": [],
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
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "((node_memory_MemTotal_bytes{instance=\"$node\",job=\"$job\"} - node_memory_MemFree_bytes{instance=\"$node\",job=\"$job\"}) / (node_memory_MemTotal_bytes{instance=\"$node\",job=\"$job\"} )) * 100",
					"format": "time_series",
					"hide": true,
					"intervalFactor": 1,
					"refId": "A",
					"step": 240
				},
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "100 - ((node_memory_MemAvailable_bytes{instance=\"$node\",job=\"$job\"} * 100) / node_memory_MemTotal_bytes{instance=\"$node\",job=\"$job\"})",
					"format": "time_series",
					"hide": false,
					"intervalFactor": 1,
					"refId": "B",
					"step": 240
				}
			],
			"title": "Cross Cluster RAM Used",
			"transparent": true,
			"type": "gauge"
		},
		{
			"datasource": {
				"type": "prometheus",
				"uid": "Prometheus"
			},
			"description": "xotocross busy state of all cpu cores together (15 min average)",
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
				"h": 5,
				"w": 3,
				"x": 9,
				"y": 71
			},
			"id": 19,
			"links": [],
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
			"pluginVersion": "9.5.20",
			"targets": [
				{
					"datasource": {
						"type": "prometheus",
						"uid": "Prometheus"
					},
					"expr": "avg(node_load15{instance=\"$node\",job=\"$job\"}) /  count(count(node_cpu_seconds_total{instance=\"$node\",job=\"$job\"}) by (cpu)) * 100",
					"hide": false,
					"intervalFactor": 1,
					"refId": "A",
					"step": 240
				}
			],
			"title": "Cross Cluster System Load (15m avg)",
			"transparent": true,
			"type": "gauge"
		}
	],
	"refresh": "",
	"schemaVersion": 38,
	"style": "dark",
	"tags": [],
	"templating": {
		"list": [
			{
				"current": {
					"selected": false,
					"text": "fluentbit",
					"value": "fluentbit"
				},
				"datasource": {
					"type": "prometheus",
					"uid": "Prometheus"
				},
				"definition": "",
				"hide": 0,
				"includeAll": false,
				"label": "Job",
				"multi": false,
				"name": "job",
				"options": [],
				"query": {
					"query": "label_values(node_uname_info, job)",
					"refId": "Prometheus-job-Variable-Query"
				},
				"refresh": 1,
				"regex": "",
				"skipUrlSync": false,
				"sort": 1,
				"tagValuesQuery": "",
				"tagsQuery": "",
				"type": "query",
				"useTags": false
			},
			{
				"current": {
					"selected": false,
					"text": "172.31.0.26:2020",
					"value": "172.31.0.26:2020"
				},
				"datasource": {
					"type": "prometheus",
					"uid": "Prometheus"
				},
				"definition": "label_values(node_uname_info{job=\"$job\"}, instance)",
				"hide": 0,
				"includeAll": false,
				"label": "Host",
				"multi": false,
				"name": "node",
				"options": [],
				"query": {
					"query": "label_values(node_uname_info{job=\"$job\"}, instance)",
					"refId": "Prometheus-node-Variable-Query"
				},
				"refresh": 1,
				"regex": "",
				"skipUrlSync": false,
				"sort": 1,
				"tagValuesQuery": "",
				"tagsQuery": "",
				"type": "query",
				"useTags": false
			},
			{
				"current": {
					"selected": false,
					"text": "[a-z]+|nvme[0-9]+n[0-9]+|mmcblk[0-9]+",
					"value": "[a-z]+|nvme[0-9]+n[0-9]+|mmcblk[0-9]+"
				},
				"hide": 2,
				"includeAll": false,
				"multi": false,
				"name": "diskdevices",
				"options": [
					{
						"selected": true,
						"text": "[a-z]+|nvme[0-9]+n[0-9]+|mmcblk[0-9]+",
						"value": "[a-z]+|nvme[0-9]+n[0-9]+|mmcblk[0-9]+"
					}
				],
				"query": "[a-z]+|nvme[0-9]+n[0-9]+|mmcblk[0-9]+",
				"skipUrlSync": false,
				"type": "custom"
			}
		]
	},
	"time": {
		"from": "now-15m",
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
		"time_options": ["5m", "15m", "1h", "6h", "12h", "24h", "2d", "7d", "30d"]
	},
	"timezone": "browser",
	"title": "xotocross logs : ${cost_project} - ${environment}"
}
