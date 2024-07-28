####################### DATA

data "aws_lambda_layer_version" "xtcross-cross-layer" {
  layer_name = "xtcross-cross-layer" 
}

data "aws_sns_topic" "xtcross-cloudwatch-sns" {
  name = "xtcross-${var.environment}-sns"
}

####################### VARIABLE

variable "environment" { description = "xtcross environment" }
variable "xtcross-task-count" { description = "xtcross task count" }
variable "xtcross-service-name" { description = "xtcross name of the service" }
variable "xtcross-function-name" { description = "xtcross name of the function" }
variable "xtcross-lambda-role-arn" { description = "xtcross arn of the lambda policy function" }

####################### MODULE

module "xtcross-scheduletask" {
  source = "terraform-aws-modules/lambda/aws"
  function_name = var.xtcross-function-name
  handler = "lambda.handler"
  runtime = "nodejs20.x"
  
  layers = [
    data.aws_lambda_layer_version.xtcross-cross-layer.arn
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
  lambda_role = var.xtcross-lambda-role-arn
}

####################### RESOURCE

resource "aws_cloudwatch_event_rule" "xtcross-scheduletask-stop-rule" {
  name = "${var.xtcross-function-name}-stop-rule"
  schedule_expression = "cron(0 22 * * ? *)"
}

resource "aws_cloudwatch_event_target" "xtcross-scheduletask-stop-target" {
  rule = aws_cloudwatch_event_rule.xtcross-scheduletask-stop-rule.name
  target_id = "${var.xtcross-function-name}-stop-resources"
  arn = module.xtcross-scheduletask.lambda_function_arn

  input = jsonencode({
    serviceName = var.xtcross-service-name,
    taskCount = var.xtcross-task-count,
    action = "stop"
  })
}

resource "aws_cloudwatch_event_rule" "xtcross-scheduletask-start-rule" {
  name = "${var.xtcross-function-name}-start-rule"
  schedule_expression = "cron(0 6 * * ? *)"
}

resource "aws_cloudwatch_event_target" "xtcross-scheduletask-start-target" {
  rule = aws_cloudwatch_event_rule.xtcross-scheduletask-start-rule.name
  target_id = "${var.xtcross-function-name}-start-resources"
  arn = module.xtcross-scheduletask.lambda_function_arn
  input = jsonencode({
    serviceName = var.xtcross-service-name,
    taskCount = var.xtcross-task-count,
    action = "start"
  })
}

resource "aws_cloudwatch_metric_alarm" "xtcross-scheduletask-alarm" {
  alarm_name = "${var.xtcross-function-name}-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "Errors"
  namespace = "AWS/Lambda"
  period = "300"
  statistic = "SampleCount"
  threshold = "1"
  alarm_description = "xtcross metric checks if there are any errors from the lambda function"
  alarm_actions = [data.aws_sns_topic.xtcross-cloudwatch-sns.arn]
  
  dimensions = {
    FunctionName = var.xtcross-function-name
  }
  
  tags = {
    Name = "${var.xtcross-function-name}-alarm"
    environment = var.environment
  }
}

