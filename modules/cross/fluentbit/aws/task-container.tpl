{
  "name": "${xtcross-container-name}",
  "image": "${xtcross-container-image}",
  "essential":  ${xtcross-container-essential},
  "portMappings": ${xtcross-container-portmap},
  "environment" : ${xtcross-container-environment},
  "logConfiguration": {"logDriver": "awslogs", "options": { "awslogs-group": "${xtcross-container-loggroup}", "awslogs-region": "${xtcross-container-region}", "awslogs-stream-prefix": "${xtcross-container-name}"}},
  "command": ${xtcross-container-command},
  "entryPoint": ${xtcross-container-entrypoint},
  "dependsOn": ${xtcross-container-dependency},
  "healthCheck": ${xtcross-container-healthcheck},
  "firelensConfiguration": ${xtcross-container-firelensconfiguration}
}
