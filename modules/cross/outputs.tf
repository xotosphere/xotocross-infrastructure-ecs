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
