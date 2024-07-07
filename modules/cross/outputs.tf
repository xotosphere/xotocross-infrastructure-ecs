output "xotocross-container-definition-global" {
  value       = local.xotocross-container-definition-global
  description = "Global container definition for the xotocross service, including monitoring if enabled."
}

output "xotocross-healthcheck-paths-global" {
  value       = local.xotocross-healthcheck-paths-global
  description = "Global health check paths for the xotocross service, including the root path if monitoring is enabled."
}

output "xotocross-listener-hosts-global" {
  value       = local.xotocross-listener-hosts-global
  description = "Global listener hosts for the xotocross service, including the Fluent Bit monitoring host if monitoring is enabled."
}

output "xotocross-container-ports-global" {
  value       = local.xotocross-container-ports-global
  description = "Global container ports for the xotocross service, including the Fluent Bit monitoring port if monitoring is enabled."
}

output "xotocross-host-ports-global" {
  value       = local.xotocross-host-ports-global
  description = "Global host ports for the xotocross service, including the Fluent Bit monitoring port if monitoring is enabled."
}
