################# cloudwatch

resource "aws_cloudwatch_log_group" "xotocross-cluster-log-group" {
  name = var.xotocross-cluster-log-group-name
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
	alarm_actions       = [aws_sns_topic.xotocross-cpu-cap-sns.arn]
	dimensions = {
		ClusterName = var.xotocross-cluster-name
		ServiceName = var.xotocross-service-name
	}
}

resource "aws_sns_topic_subscription" "xotocross-cpu-cap-sns" {
  for_each  = toset(var.xotocross-email)
  topic_arn = aws_sns_topic.xotocross-cpu-cap-sns.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_sns_topic" "xotocross-cpu-cap-sns" {
	name = "${var.xotocross-service-name}-${var.environment}-cpu-cap-alarm"
}