{
  "name": "${xotocross-container-name}",
  "image": "${xotocross-container-image}",
  "cpu": ${xotocross-container-cpu},
  "memory": ${xotocross-container-memory},
  "essential":  ${xotocross-container-essential},
  "portMappings": ${xotocross-port-mapping},
  "environment" : ${xotocross-environment},
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-group": "${xotocross-log-group-name}",
      "awslogs-region": "${xotocross-region}",
      "awslogs-stream-prefix": "${xotocross-container-name}"
    }
  },
  "command": ${xotocross-container-command},
  "entryPoint": ${xotocross-container-entrypoint},
  "dependsOn": ${xotocross-container-dependency},
  "healthCheck": ${xotocross-container-healthcheck},
  "firelensConfiguration": ${xotocross-container-firelensconfiguration}
}
