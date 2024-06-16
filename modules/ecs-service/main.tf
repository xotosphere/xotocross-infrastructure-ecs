resource "aws_ecs_task_definition" "xotocross-ecs-task-definition" {
  family = var.xotocross-task-family
  container_definitions = var.xotocross-container-definition
  execution_role_arn = var.xotocross-execution-role-arn
  task_role_arn = var.xotocross-task-role-arn
  network_mode = var.xotocross-network-mode
  requires_compatibilities = ["EC2"]
}

resource "aws_ecs_service" "xotocross-ecs-service" {
  count = length(var.xotocross-container-port)

  name = "${var.xotocross-service-name}-${var.xotocross-container-port[count.index]}"
  cluster = var.xotocross-ecs-cluster-id
  task_definition = aws_ecs_task_definition.xotocross-ecs-task-definition.arn
  deployment_maximum_percent = var.xotocross-deployment-max
  deployment_minimum_healthy_percent = var.xotocross-deployment-min
  desired_count = var.xotocross-desired-count
  launch_type = "EC2"

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = var.xotocross-target-group-arn 
    container_name = var.xotocross-container-name
    container_port = var.xotocross-container-port[count.index]
  }

  deployment_circuit_breaker {
    enable = var.xotocross-enable-deployment-circuit-breaker
    rollback = var.xotocross-enable-rollback
  }

  placement_constraints {
    type = var.xotocross-placement-constraint-type
    expression = var.xotocross-placement-constraint-expression
  }

  enable_ecs_managed_tags = var.xotocross-enable-ecs-managed-tags
  propagate_tags = var.xotocross-propagate-tags
  enable_execute_command = var.xotocross-enable-execute-command
  health_check_grace_period_seconds = var.xotocross-health-check-grace-period
  iam_role = var.xotocross-iam-role
}