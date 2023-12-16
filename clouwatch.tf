resource "aws_cloudwatch_metric_alarm" "alarm-5xx" {
  count               = var.cloudwatch_alarm["5xx"] == "1" ? 1 : 0
  alarm_name          = "5xx-${var.name}-Prod"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_Target_5XX_Count"
  dimensions = {
    "LoadBalancer" = data.aws_lb.this.arn_suffix
    "TargetGroup"  = aws_lb_target_group.this[0].arn_suffix
  }
  period                    = 60
  statistic                 = "Sum"
  threshold                 = 4
  alarm_actions             = [var.sns_topic_arn]
  alarm_description         = "This metric monitors 5xx count in target group"
  insufficient_data_actions = []
  #ok_actions                = [var.sns_topic_arn]

  lifecycle {
    ignore_changes = [
      threshold
    ]
  }
}