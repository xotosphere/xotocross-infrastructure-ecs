data "aws_lambda_layer_version" "xotocross-core-layer" {
  layer_name = "xotocross-core-layer" 
}

data "aws_sns_topic" "xotocross-sns" {
  name = "xotocross-${var.environment}-ec2-sns"
}