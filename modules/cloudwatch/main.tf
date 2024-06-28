################# cloudwatch

resource "aws_cloudwatch_log_group" "xotocross-log-group" {
  name = var.xotocross-log-group-name
}

resource "aws_cloudwatch_metric_alarm" "xotocross-cpu-cap-alarm" {
	alarm_name          = "${var.xotocross-service-name}-${var.environment}-cpu-cap-alarm"
	comparison_operator = "GreaterThanThreshold"
	evaluation_periods  = "2"
	metric_name         = "CPUUtilization"
	namespace           = "AWS/ECS"
	period              = "300"
	statistic           = "Average"
	threshold           = "80"
	alarm_description   = "xotocross metric checks if cpu utilization is above 80%"
	alarm_actions       = [aws_sns_topic.xotocross-cpu-cap-alarm.arn]
	dimensions = {
		ClusterName = var.xotocross-cluster-name
		ServiceName = var.xotocross-service-name
	}
}

resource "aws_sns_topic_subscription" "email_subscriptions" {
  for_each  = toset(var.xotocross-email)
  topic_arn = aws_sns_topic.xotocross-cpu-cap-alarm.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_sns_topic" "xotocross-cpu-cap-alarm" {
	name = "${var.xotocross-service-name}-${var.environment}-cpu-cap-alarm"
}