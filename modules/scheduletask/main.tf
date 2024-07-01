resource "null_resource" "xotocross-layer-prepare" {
  provisioner "local-exec" {
    command = <<EOF
      mkdir -p ${path.module}/nodejs/node_modules &&
      cp -R ${path.module}/package.json ${path.module}/nodejs/ &&
      cp -R ${path.module}/package-lock.json ${path.module}/nodejs/ &&
      npm --prefix ${path.module}/nodejs install &&
      cd ${path.module} && zip -r xotocross-${var.xotocross-service-name}-layer.zip nodejs
    EOF
  }
  triggers = {
    always-run = "${timestamp()}"
  }
}

resource "aws_s3_object" "object" {
  bucket     = var.xotocross-bucket-name
  key        = "xotocross-${var.xotocross-service-name}-layer.zip"
  source     = "${path.module}/xotocross-${var.xotocross-service-name}-layer.zip"
  acl        = "private"
  depends_on = [null_resource.xotocross-layer-prepare]
}

resource "aws_lambda_layer_version" "xotocross-lambda-layer" {
  s3_bucket           = aws_s3_object.object.bucket
  s3_key              = aws_s3_object.object.key
  layer_name          = "xotocross-${var.xotocross-service-name}-layer"
  compatible_runtimes = ["nodejs20.x"]
  depends_on          = [aws_s3_object.object]
}

module "xotocross-scheduletask" {
  source        = "terraform-aws-modules/lambda/aws"
  function_name = var.xotocross-service-name
  handler       = "lambda.handler"
  runtime       = "nodejs20.x"
  layers        = [aws_lambda_layer_version.xotocross-lambda-layer.arn]
  source_path = [
    {
      path             = "${path.module}/lambda.js",
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

resource "aws_cloudwatch_event_rule" "xotocross-stop-task" {
  name                = "xotocross-${var.xotocross-service-name}-stop"
  schedule_expression = "cron(0 22 * * ? *)"
}

resource "aws_cloudwatch_event_target" "xotocross-stop-task-target" {
  rule      = aws_cloudwatch_event_rule.xotocross-stop-task.name
  target_id = "xotocross-${var.xotocross-service-name}-stop"
  arn       = module.xotocross-scheduletask.lambda_function_arn

  input = jsonencode({
    action               = "stop"
  })
}

resource "aws_cloudwatch_event_rule" "xotocross-start-task" {
  name                = "xotocross-${var.xotocross-service-name}-start"
  schedule_expression = "cron(0 6 * * ? *)"
}

resource "aws_cloudwatch_event_target" "xotocross-start-task-target" {
  rule      = aws_cloudwatch_event_rule.xotocross-start-task.name
  target_id = "xotocross-${var.xotocross-service-name}-start"
  arn       = module.xotocross-scheduletask.lambda_function_arn
  input = jsonencode({
    action               = "start"
  })
}

resource "aws_cloudwatch_metric_alarm" "xotocross-stop-task-alarm" {
  alarm_name          = "xotocross-${var.xotocross-service-name}-stop-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "SampleCount"
  threshold           = "1"
  alarm_description   = "xotocross metric checks if there are any errors from the lambda function"
  alarm_actions       = [aws_sns_topic.xotocross-stop-task-sns.arn]
  dimensions = {
    FunctionName =  var.xotocross-service-name
  }
}

resource "aws_sns_topic" "xotocross-stop-task-sns" {
  name = "xotocross-${var.xotocross-service-name}-stop-sns"
}

resource "aws_sns_topic_subscription" "xotocross-stop-task-email" {
  for_each   = toset(var.xotocross-email)
  topic_arn  = aws_sns_topic.xotocross-stop-task-sns.arn
  protocol   = "email"
  endpoint   = each.value
}

resource "aws_cloudwatch_log_group" "xotocross-scheduletask-log-group" {
  name = var.xotocross-log-group-name
  retention_in_days = 14
}