####################### OUTPUT

output "xtcross-container-definition" {
  value = local.xtcross-container-definition
  description = "xtcross container definition"
}

output "xtcross-healthcheck-pathlist" {
  value = local.xtcross-healthcheck-pathlist
  description = "xtcross healthcheck pathlist"
}

output "xtcross-listener-hostlist" {
  value = local.xtcross-listener-hostlist
  description = "xtcross listener hostlist"
}

output "xtcross-container-portlist" {
  value = local.xtcross-container-portlist
  description = "xtcross container portlist"
}

output "xtcross-host-portlist" {
  value = local.xtcross-host-portlist
  description = "xtcross host portlist"
}
