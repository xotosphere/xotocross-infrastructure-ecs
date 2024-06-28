################# cloudwatch

resource "aws_cloudwatch_log_group" "xotocross-log-group" {
  name = "${var.xotocross-log-group-name}"
}

resource "aws_cloudwatch_metric_alarm" "xotocross-cpu-utilization-high" {
	alarm_name          = "xotocross-${var.xotocross-service-name}-${var.environment}-utilization-high"
	comparison_operator = "GreaterThanThreshold"
	evaluation_periods  = "2"
	metric_name         = "CPUUtilization"
	namespace           = "AWS/ECS"
	period              = "300"
	statistic           = "Average"
	threshold           = "80"
	alarm_description   = "This metric checks if CPU utilization is above 80%"
	alarm_actions       = [aws_sns_topic.xotocross-cpu-utilization-high.arn]
	dimensions = {
		ClusterName = var.xotocross-ecs-cluster-id
		ServiceName = var.xotocross-service-name
	}
}

resource "aws_sns_topic_subscription" "xotocross-cpu-utilization-high_email" {
  topic_arn = aws_sns_topic.xotocross-cpu-utilization-high.arn
  protocol  = "email"
  endpoint  = "xotosphere@gmail.com"
}

resource "aws_sns_topic" "xotocross-cpu-utilization-high" {
	name = "xotocross-cpu-utilization-high"
}