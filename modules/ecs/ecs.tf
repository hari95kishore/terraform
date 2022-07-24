module "network" {
  source       = "../network"
  service_name = var.service_name
}

resource "aws_ecs_task_definition" "elopage_ecs_task_definition" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions    = var.container_definitions
}

resource "aws_ecs_cluster" "elopage_ecs_cluster" {
  name = var.service_name
}

resource "aws_ecs_service" "elopage_ecs_service" {

  name                   = var.service_name
  cluster                = aws_ecs_cluster.elopage_ecs_cluster.id
  task_definition        = aws_ecs_task_definition.elopage_ecs_task_definition.arn
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  enable_execute_command = var.enable_execute_command

  network_configuration {
    assign_public_ip = false
    security_groups  = var.security_groups
    subnets          = module.network.private_subnets
  }

  load_balancer {
    target_group_arn = module.network.alb-tg-arn
    container_name   = var.service_name
    container_port   = 80
  }

}