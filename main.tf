module "network" {
  source       = "./modules/network"
  service_name = var.service_name
}

# create ecr repo to upload the image 
module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "${var.service_name}"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

}

# security group of the application
resource "aws_security_group" "ecs_sg" {
  name   = "${var.service_name}-task-security-group"
  vpc_id = module.network.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.container_port
    to_port         = var.container_port
    security_groups = [module.network.alb-sg-id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Uses ecs module to create ecs cluster and ecs service
module "calculator" {
  source = "./modules/ecs"

  service_name           = var.service_name
  service_port           = var.service_port
  desired_count          = var.desired_count
  cpu                    = var.cpu
  memory                 = var.memory
  enable_execute_command = var.enable_execute_command
  security_groups        = [aws_security_group.ecs_sg.id]
  ecs_subnets            = module.network.private_subnets
  alb-tg-arn             = module.network.alb-tg-arn
  alb_arn_suffix         = module.network.alb-arn-suffix
  tg_arn_suffix          = module.network.tg-arn-suffix
  container_definitions = jsonencode([{
    "image" : "330561029327.dkr.ecr.eu-central-1.amazonaws.com/${var.service_name}:latest",
    "name" : "${var.service_name}",
    "networkMode" : "awsvpc",
    "portMappings" : [{
      "containerPort" : var.container_port,
      "hostPort" : var.container_port
    }]

  }])

}