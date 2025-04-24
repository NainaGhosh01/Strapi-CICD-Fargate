resource "aws_ecs_cluster" "strapi_cluster" {
  name = "naina-strapi-cluster"
}

resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = aws_iam_role.naina_ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = var.strapi_image

      essential = true
      portMappings = [
        {
          containerPort = 1337
        }
      ]
      environment = [
        {
          name  = "HOST"
          value = "0.0.0.0"
        } ,

        {
          name  = "PORT"
          value = "1337"
        } ,

        {
          name  = "VITE_HOST"
          value = "0.0.0.0"
        },
        {
          name  = "VITE_SERVER_ALLOWED_HOSTS"
          value = "naina-strapi-alb-1410829428.us-east-1.elb.amazonaws.com"
        }


      ]
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:1337 || exit 1"]
        interval    = 30
        timeout     = 10
        retries     = 5
        startPeriod = 60
      }
    }
  ])
}

resource "aws_ecs_service" "strapi_service" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_tg.arn
    container_name   = "strapi"
    container_port   = 1337
  }
}
