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

module "xotocross-scheduler-function" {
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

resource "aws_cloudwatch_event_rule" "xotocross-stop" {
  name                = "xotocross-${var.xotocross-service-name}-stop"
  schedule_expression = "cron(0 22 * * ? *)"
}

resource "aws_cloudwatch_event_target" "xotocross-stop-target" {
  rule      = aws_cloudwatch_event_rule.xotocross-stop.name
  target_id = "xotocross-${var.xotocross-service-name}-stop"
  arn       = module.xotocross-scheduler-function.lambda_function_arn

  input = jsonencode({
    action               = "stop"
    scalingGroupName = var.xotocross-asg-name
    capacity            = 0
  })
}

resource "aws_cloudwatch_event_rule" "xotocross-start" {
  name                = "xotocross-${var.xotocross-service-name}-start"
  schedule_expression = "cron(0 6 * * ? *)"
}

resource "aws_cloudwatch_event_target" "xotocross-start-target" {
  rule      = aws_cloudwatch_event_rule.xotocross-start.name
  target_id = "xotocross-${var.xotocross-service-name}-start"
  arn       = module.xotocross-scheduler-function.lambda_function_arn
  input = jsonencode({
    action               = "start"
    scalingGroupName = var.xotocross-asg-name
    capacity            = var.xotocross-capacity
  })
}

resource "aws_cloudwatch_metric_alarm" "xotocross-stop-alarm" {
  alarm_name          = "xotocross-${var.xotocross-service-name}-stop-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "SampleCount"
  threshold           = "1"
  alarm_description   = "xotocross metric checks if there are any errors from the lambda function"
  alarm_actions       = [aws_sns_topic.xotocross-stop-sns.arn]
  dimensions = {
    FunctionName =  var.xotocross-service-name
  }
}

resource "aws_sns_topic" "xotocross-stop-sns" {
  name = "xotocross-${var.xotocross-service-name}-stop-sns"
}

resource "aws_sns_topic_subscription" "xotocross-stop-email" {
  for_each   = toset(var.xotocross-email)
  topic_arn  = aws_sns_topic.xotocross-stop-sns.arn
  protocol   = "email"
  endpoint   = each.value
}

resource "aws_cloudwatch_log_group" "xotocross-scheduler-function-log-group" {
  name = var.xotocross-cluster-log-group-name
  retention_in_days = 14
}