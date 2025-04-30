resource "aws_ecs_cluster" "strapi_cluster" {
  name = "naina-strapi-cluster"
}

resource "aws_cloudwatch_log_group" "strapi_logs" {
  name              = "/ecs/strapi"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.naina_ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "strapi"
    image     = var.strapi_image
    essential = true
    portMappings = [{
      containerPort = 1337
    }],
    environment = [
      {
        name  = "HOST"
        value = "0.0.0.0"
      },
      {
        name  = "PORT"
        value = "1337"
      }
    ],
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/strapi"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs/strapi"
      }
    }
  }])
}

resource "aws_ecs_service" "strapi_service" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  platform_version = "LATEST"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_tg_blue.arn
    container_name   = "strapi"
    container_port   = 1337
  }
}
