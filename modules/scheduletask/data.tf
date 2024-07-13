data "aws_lambda_layer_version" "xotocross-cross-layer" {
  layer_name = "xotocross-cross-layer" 
}

data "aws_sns_topic" "xotocross-cloudwatch-sns" {
  name = "xotocross-${var.environment}-sns"
}