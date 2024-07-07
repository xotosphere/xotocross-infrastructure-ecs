
module "xotocross-scheduletask-function" {
  source = "terraform-aws-modules/lambda/aws"
  function_name = var.xotocross-function-name
  handler = "lambda.handler"
  runtime = "nodejs20.x"
  layers = [
    data.aws_lambda_layer_version.xotocross-core-layer.arn
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

resource "aws_cloudwatch_event_rule" "xotocross-scheduletask-stop-rule" {
  name = "${var.xotocross-function-name}-stop-rule"
  schedule_expression = "cron(0 22 * * ? *)"
}

resource "aws_cloudwatch_event_target" "xotocross-scheduletask-stop-target" {
  rule = aws_cloudwatch_event_rule.xotocross-scheduletask-stop-rule.name
  target_id = "${var.xotocross-function-name}-stop-resources"
  arn = module.xotocross-scheduletask-function.lambda_function_arn

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
  arn = module.xotocross-scheduletask-function.lambda_function_arn
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
  alarm_actions = [aws_sns_topic.xotocross-scheduletask-sns.arn]
  dimensions = {
    FunctionName = var.xotocross-function-name
  }
}

resource "aws_sns_topic" "xotocross-scheduletask-sns" {
  name = "${var.xotocross-function-name}-sns"
}

resource "aws_sns_topic_subscription" "xotocross-scheduletask-email" {
  for_each = toset(var.xotocross-email)
  topic_arn = aws_sns_topic.xotocross-scheduletask-sns.arn
  protocol = "email"
  endpoint = each.value
}
