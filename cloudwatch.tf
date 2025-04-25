resource "aws_cloudwatch_dashboard" "strapi_dashboard" {
  dashboard_name = "strapi-ecs-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0,
        y    = 0,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "ECS/ContainerInsights", "CPUUtilization", "ClusterName", aws_ecs_cluster.strapi_cluster.name ],
            [ ".", "MemoryUtilization", ".", "." ]
          ],
          period = 300,
          stat   = "Average",
          region = var.aws_region,
          title  = "CPU & Memory Usage"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-strapi"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm monitors high CPU usage for Strapi ECS"
  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster.name
    ServiceName = aws_ecs_service.strapi_service.name
  }
}
