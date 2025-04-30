blue_green_deployment_config {
  deployment_ready_option {
    action_on_timeout = "CONTINUE_DEPLOYMENT"
  }

  terminate_blue_instances_on_deployment_success {
    action = "TERMINATE"
    termination_wait_time_in_minutes = 5
  }

  green_fleet_provisioning_option {
    action = "DISCOVER_EXISTING"
  }
}

load_balancer_info {
  target_group_pair_info {
    target_group {
      name = aws_lb_target_group.strapi_tg_green.name  # Correct reference
    }

    target_group {
      name = aws_lb_target_group.strapi_tg_blue.name   # Correct reference
    }

    prod_traffic_route {
      listener_arns = [aws_lb_listener.http_listener.arn]
    }
  }
}
