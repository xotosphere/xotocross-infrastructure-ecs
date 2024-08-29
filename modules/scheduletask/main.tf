####################### DATA

data "aws_lambda_layer_version" "xtcross-cross-layer" {
  layer_name = "${var.prefix}-${var.environment}-layer"
}

data "aws_sns_topic" "xtcross-cloudwatch-sns" {
  name = "${var.prefix}-${var.environment}-sns"
}

####################### VARIABLE

variable "environment" { description = "xtcross environment" }
variable "prefix" { description = "xtcross prefix" }
variable "xtcross-function-name" { description = "xtcross name of the function" }
variable "xtcross-lambda-role-arn" { description = "xtcross arn of the lambda policy function" }

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
  alarm_actions       = [data.aws_sns_topic.xtcross-cloudwatch-sns.arn]

  dimensions = {
    FunctionName = var.xtcross-function-name
  }

  tags = {
    Name = "${var.xtcross-function-name}-alarm"
    environment = var.environment
  }
}

