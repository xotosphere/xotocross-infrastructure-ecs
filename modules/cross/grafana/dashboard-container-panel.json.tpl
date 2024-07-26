{
    "datasource": {
        "type": "loki",
        "uid": "Loki"
    },
    "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 1
    },
    "id": 277,
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
            "expr": "{cost_project=\"${cost_project}\", container=\"${container_name}\"} | line_format `{{.log}}`",
            "queryType": "range",
            "refId": "A"
        }
    ],
    "title": "Cross App Logs ${cost_project} ${container_name}",
    "transformations": [],
    "transparent": true,
    "type": "logs"
}