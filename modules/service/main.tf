####################### VARIABLE

variable "region" { description = "xtcross region" }
variable "environment" { description = "xtcross environment" }
variable "xtcross-cluster-name" { description = "xtcross ecs cluster name" }
variable "xtcross-task-family" { description = "xtcross task family" }
variable "xtcross-container-definition" { description = "xtcross container definition" }
variable "xtcross-execution-role-arn" { description = "xtcross execution role arn" }
variable "xtcross-task-role-arn" { description = "xtcross task role arn" }
variable "xtcross-service-name" { description = "xtcross service name" }
variable "xtcross-container-port" { description = "xtcross list of ports" }
variable "xtcross-desired-count" { description = "xtcross desired count" }
variable "xtcross-deployment-max" { description = "xtcross deployment max" }
variable "xtcross-deployment-min" { description = "xtcross deployment min" }
variable "xtcross-constraint-placement" { description = "xtcross placement constraint type" }
variable "xtcross-constraint-expression" { description = "xtcross placement constraint expression" }
variable "xtcross-healthcheck-grace" { description = "xtcross health check grace period" }
variable "xtcross-network-mode" { description = "xtcross network mode" }
variable "xtcross-targetgroup-arnlist" { description = "xtcross target group arn" }
variable "xtcross-listener-hostlist" { description = "xtcross listener hosts" }

####################### RESOURCE

data "aws_efs_file_system" "xtcross-fs" {
  tags = {
    Name = "${var.xtcross-cluster-name}-fs"
  }
}

resource "aws_efs_access_point" "xtcross-accesspoint" {
  file_system_id = data.aws_efs_file_system.xtcross-fs.id

  root_directory {
    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 755
    }
    path = "/${var.xtcross-service-name}"
  }

  posix_user {
    gid = 0
    uid = 0
  }
}

resource "aws_ecs_task_definition" "xtcross-task-definition" {
  family                   = var.xtcross-task-family
  container_definitions    = jsonencode(var.xtcross-container-definition)
  execution_role_arn       = var.xtcross-execution-role-arn
  task_role_arn            = var.xtcross-task-role-arn
  network_mode             = var.xtcross-network-mode
  requires_compatibilities = ["EC2"]

  volume {
    name = "${var.xtcross-service-name}-volume"
    efs_volume_configuration {
      file_system_id     = data.aws_efs_file_system.xtcross-fs.id
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = aws_efs_access_point.xtcross-accesspoint.id
        iam             = "ENABLED"
      }
    }
  }
}

resource "aws_ecs_service" "xtcross-service" {
  name                               = "xtcross-${var.xtcross-service-name}-${var.environment}-service"
  cluster                            = var.xtcross-cluster-name
  task_definition                    = aws_ecs_task_definition.xtcross-task-definition.arn
  deployment_maximum_percent         = var.xtcross-deployment-max
  deployment_minimum_healthy_percent = var.xtcross-deployment-min
  desired_count                      = var.xtcross-desired-count
  launch_type                        = "EC2"

  deployment_controller {
    type = "ECS"
  }

  dynamic "load_balancer" {
    for_each = range(0, length(var.xtcross-listener-hostlist))
    iterator = count

    content {
      target_group_arn = var.xtcross-targetgroup-arnlist[count.value]
      container_name   = var.xtcross-container-definition[count.value].name
      container_port   = var.xtcross-container-port[count.value]
    }
  }

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  placement_constraints {
    type       = var.xtcross-constraint-placement
    expression = var.xtcross-constraint-expression
  }

  enable_ecs_managed_tags           = false
  propagate_tags                    = "SERVICE"
  enable_execute_command            = false
  health_check_grace_period_seconds = var.xtcross-healthcheck-grace

  service_connect_configuration {
    enabled   = true
    namespace = "${var.environment}.local"

    dynamic "service" {
      for_each = range(0, length(var.xtcross-container-definition))
      iterator = count

      content {
        discovery_name = var.xtcross-container-definition[count.value].name
        port_name      = "port-${var.xtcross-container-port[count.value]}"

        client_alias {
          dns_name = "${var.xtcross-container-definition[count.value].name}.${var.environment}.local"
          port     = var.xtcross-container-port[count.value]
        }
      }
    }
  }
}
