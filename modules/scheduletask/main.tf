####################### DATA

data "aws_lambda_layer_version" "xotocross-cross-layer" {
  layer_name = "xotocross-cross-layer" 
}

data "aws_sns_topic" "xotocross-cloudwatch-sns" {
  name = "xotocross-${var.environment}-sns"
}

####################### VARIABLE

variable "environment" { description = "xotocross environment (e.g. dev, stage, prod, infra)" }
variable "xotocross-task-count" { description = "xotocross task count" }
variable "xotocross-service-name" { description = "xotocross name of the service" }
variable "xotocross-function-name" { description = "xotocross name of the function" }
variable "xotocross-lambda-role-arn" { description = "xotocross arn of the lambda policy function" }

####################### MODULE

module "xotocross-scheduletask" {
  source = "terraform-aws-modules/lambda/aws"
  function_name = var.xotocross-function-name
  handler = "lambda.handler"
  runtime = "nodejs20.x"
  
  layers = [
    data.aws_lambda_layer_version.xotocross-cross-layer.arn
  ]
  
  source_path = [
    {
      path = "${path.module}/lambda.js",
      npm_requirements = false,
      commands = [
        ":zip"
      ],
    },
  ]
  
  environment_variables = {
    environment = var.environment
  }

  create_role = false
  lambda_role = var.xotocross-lambda-role-arn
}

####################### RESOURCE

resource "aws_cloudwatch_event_rule" "xotocross-scheduletask-stop-rule" {
  name = "${var.xotocross-function-name}-stop-rule"
  schedule_expression = "cron(0 22 * * ? *)"
}

resource "aws_cloudwatch_event_target" "xotocross-scheduletask-stop-target" {
  rule = aws_cloudwatch_event_rule.xotocross-scheduletask-stop-rule.name
  target_id = "${var.xotocross-function-name}-stop-resources"
  arn = module.xotocross-scheduletask.lambda_function_arn

  input = jsonencode({
    serviceName = var.xotocross-service-name,
    taskCount = var.xotocross-task-count,
    action = "stop"
  })
}

resource "aws_cloudwatch_event_rule" "xotocross-scheduletask-start-rule" {
  name = "${var.xotocross-function-name}-start-rule"
  schedule_expression = "cron(0 6 * * ? *)"
}

resource "aws_cloudwatch_event_target" "xotocross-scheduletask-start-target" {
  rule = aws_cloudwatch_event_rule.xotocross-scheduletask-start-rule.name
  target_id = "${var.xotocross-function-name}-start-resources"
  arn = module.xotocross-scheduletask.lambda_function_arn
  input = jsonencode({
    serviceName = var.xotocross-service-name,
    taskCount = var.xotocross-task-count,
    action = "start"
  })
}

resource "aws_cloudwatch_metric_alarm" "xotocross-scheduletask-alarm" {
  alarm_name = "${var.xotocross-function-name}-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "Errors"
  namespace = "AWS/Lambda"
  period = "300"
  statistic = "SampleCount"
  threshold = "1"
  alarm_description = "xotocross metric checks if there are any errors from the lambda function"
  alarm_actions = [data.aws_sns_topic.xotocross-cloudwatch-sns.arn]
  dimensions = {
    FunctionName = var.xotocross-function-name
  }
  tags = {
    Name = "${var.xotocross-function-name}-alarm"
    environment = var.environment
  }
}

