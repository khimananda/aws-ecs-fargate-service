resource "aws_appautoscaling_target" "ecs_target" {
  count              = var.autoscaling ? 1 : 0
  max_capacity       = 5
  min_capacity       = 2
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  lifecycle {
    ignore_changes = [
      max_capacity,
      min_capacity
    ]
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  count              = var.autoscaling ? 1 : 0
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = var.autoscaling_target_value["memory"] #80
    scale_in_cooldown  = 150
    scale_out_cooldown = 150
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  count              = var.autoscaling ? 1 : 0
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.autoscaling_target_value["cpu"] #60
    scale_in_cooldown  = 150
    scale_out_cooldown = 150
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_request" {
  count              = var.autoscaling && var.enable_public_endpoint ? 1 : 0
  name               = "requestCount"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${data.aws_lb.this.arn_suffix}/${aws_lb_target_group.this[0].arn_suffix}"
    }

    target_value       = var.autoscaling_target_value["requestCount"] #60
    scale_in_cooldown  = 150
    scale_out_cooldown = 150
  }
}