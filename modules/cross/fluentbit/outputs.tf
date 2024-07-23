####################### OUTPUTS

output "xotocross-container-definition" {
  value = local.xotocross-container-definition
  description = "xotocross container definition"
}

output "xotocross-healthcheck-pathlist" {
  value = local.xotocross-healthcheck-pathlist
  description = "xotocross healthcheck pathlist"
}

output "xotocross-listener-hostlist" {
  value = local.xotocross-listener-hostlist
  description = "xotocross listener hostlist"
}

output "xotocross-container-portlist" {
  value = local.xotocross-container-portlist
  description = "xotocross container portlist"
}

output "xotocross-host-portlist" {
  value = local.xotocross-host-portlist
  description = "xotocross host portlist"
}
