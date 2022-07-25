resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.max_scaling_capacity
  min_capacity       = var.min_scaling_capacity
  resource_id        = "service/${aws_ecs_cluster.elopage_ecs_cluster.name}/${aws_ecs_service.elopage_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "alb_request_count" {
  name               = "alb-request-count"
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  policy_type        = "TargetTrackingScaling"
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${var.alb_arn_suffix}/${var.tg_arn_suffix}"
    }
    target_value       = 75
    scale_in_cooldown  = 180
    scale_out_cooldown = 180
  }
}