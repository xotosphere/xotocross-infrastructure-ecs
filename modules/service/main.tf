####################### VARIABLE

variable "region" { description = "xotocross region" }
variable "environment" { description = "xotocross environment (e.g. dev, stage, prod, infra)" }
variable "xotocross-cluster-name" { description = "xotocross ecs cluster name" }
variable "xotocross-task-family" { description = "xotocross task family" }
variable "xotocross-container-definition" { description = "xotocross container definition" }
variable "xotocross-execution-role-arn" { description = "xotocross execution role arn" }
variable "xotocross-task-role-arn" { description = "xotocross task role arn" }
variable "xotocross-service-name" { description = "xotocross service name" }
variable "xotocross-container-port" { description = "xotocross list of ports" }
variable "xotocross-desired-count" { description = "xotocross desired count" }
variable "xotocross-deployment-max" { description = "xotocross deployment max" }
variable "xotocross-deployment-min" { description = "xotocross deployment min" }
variable "xotocross-constraint-placement" { description = "xotocross placement constraint type" }
variable "xotocross-constraint-expression" { description = "xotocross placement constraint expression" }
variable "xotocross-healthcheck-grace" { description = "xotocross health check grace period" }
variable "xotocross-network-mode" { description = "xotocross network mode" }
variable "xotocross-targetgroup-arnlist" { description = "xotocross target group arn" }
variable "xotocross-domain-name" { description = "xotocross domain name" }
variable "xotocross-listener-hostlist" { description = "xotocross listener hosts" }

####################### RESOURCE

data "aws_efs_file_system" "xotocross-fs" {
  tags = {
    Name = "${var.xotocross-cluster-name}-fs"
  }
}

resource "aws_efs_access_point" "xotocross-accesspoint" {
  file_system_id = data.aws_efs_file_system.xotocross-fs.id
  root_directory {
    creation_info {
      owner_gid = 0
      owner_uid = 0
      permissions = 755
    }
    path = "/${var.xotocross-service-name}"
  }
  posix_user {
    gid = 0
    uid = 0
  }
}

resource "aws_ecs_task_definition" "xotocross-task-definition" {
  family = var.xotocross-task-family
  container_definitions = jsonencode(var.xotocross-container-definition)
  execution_role_arn = var.xotocross-execution-role-arn
  task_role_arn = var.xotocross-task-role-arn
  network_mode = var.xotocross-network-mode
  requires_compatibilities = ["EC2"]

  volume {
    name = "${var.xotocross-service-name}-volume"
    efs_volume_configuration {
      file_system_id = data.aws_efs_file_system.xotocross-fs.id
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = aws_efs_access_point.xotocross-accesspoint.id
        iam = "ENABLED"
      }
    }
  }

}

resource "aws_ecs_service" "xotocross-service" {
  name = "xotocross-${var.xotocross-service-name}-${var.environment}-service"
  cluster = var.xotocross-cluster-name
  task_definition = aws_ecs_task_definition.xotocross-task-definition.arn
  deployment_maximum_percent = var.xotocross-deployment-max
  deployment_minimum_healthy_percent = var.xotocross-deployment-min
  desired_count = var.xotocross-desired-count
  launch_type = "EC2"

  deployment_controller {
    type = "ECS"
  }

  dynamic "load_balancer" {
    for_each = range(0, length(var.xotocross-listener-hostlist))
    iterator = count

    content {
      target_group_arn = var.xotocross-targetgroup-arnlist[count.value]
      container_name = var.xotocross-container-definition[count.value].name
      container_port = var.xotocross-container-port[count.value]
    }
  }

  deployment_circuit_breaker {
    enable = false
    rollback = false
  }

  placement_constraints {
    type = var.xotocross-constraint-placement
    expression = var.xotocross-constraint-expression
  }

  enable_ecs_managed_tags = false
  propagate_tags = "SERVICE"
  enable_execute_command = false
  health_check_grace_period_seconds = var.xotocross-healthcheck-grace
}
