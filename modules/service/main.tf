data "aws_efs_file_system" "xotocross-ecs-fs" {
  tags = {
    Name = "${var.xotocross-cluster-name}-fs"
  }
}

resource "aws_efs_access_point" "xotocross-ecs-accesspoint" {
  file_system_id = data.aws_efs_file_system.xotocross-ecs-fs.id
  root_directory {
    path = var.xotocross-service-name
  }
}

resource "aws_ecs_task_definition" "xotocross-ecs-task-definition" {
  family                   = var.xotocross-task-family
  container_definitions    = jsonencode(var.xotocross-container-definition)
  execution_role_arn       = var.xotocross-execution-role-arn
  task_role_arn            = var.xotocross-task-role-arn
  network_mode             = var.xotocross-network-mode
  requires_compatibilities = ["EC2"]

  volume {
    name = "${var.xotocross-service-name}-volume"
    efs_volume_configuration {
      file_system_id = data.aws_efs_file_system.xotocross-ecs-fs.id

      authorization_config {
        access_point_id = aws_efs_access_point.xotocross-ecs-accesspoint.id
      }
    }
  }

}

resource "aws_ecs_service" "xotocross-service" {
  name                               = "xotocross-${var.xotocross-service-name}-${var.environment}-service"
  cluster                            = var.xotocross-cluster-name
  task_definition                    = aws_ecs_task_definition.xotocross-ecs-task-definition.arn
  deployment_maximum_percent         = var.xotocross-deployment-max
  deployment_minimum_healthy_percent = var.xotocross-deployment-min
  desired_count                      = var.xotocross-desired-count
  launch_type                        = var.xotocross-ecs-launch-type

  deployment_controller {
    type = "ECS"
  }

  dynamic "load_balancer" {
    for_each = range(0, length(var.xotocross-listener-hosts))
    iterator = count

    content {
      target_group_arn = var.xotocross-target-group-arns[count.value]
      container_name   = var.xotocross-container-definition[count.value].name
      container_port   = var.xotocross-container-port[count.value]
    }
  }

  deployment_circuit_breaker {
    enable   = var.xotocross-enable-deployment-circuit-breaker
    rollback = var.xotocross-enable-rollback
  }

  placement_constraints {
    type       = var.xotocross-placement-constraint-type
    expression = var.xotocross-placement-constraint-expression
  }

  enable_ecs_managed_tags           = var.xotocross-enable-ecs-managed-tags
  propagate_tags                    = var.xotocross-propagate-tags
  enable_execute_command            = var.xotocross-enable-execute-command
  health_check_grace_period_seconds = var.xotocross-healthcheck-grace-period
}
