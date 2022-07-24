module "network" {
  source       = "./modules/network"
  service_name = var.service_name
}

# create ecr repo to upload the image 
module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "calculator"
}

# security group of the application
resource "aws_security_group" "calculator_sg" {
  name   = "calculator-task-security-group"
  vpc_id = module.network.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
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

  service_name           = "calculator"
  service_port           = 80
  public_facing          = true
  desired_count          = 2
  cpu                    = 512
  memory                 = 1024
  enable_execute_command = true
  security_groups        = [aws_security_group.calculator_sg.id]
  container_definitions = jsonencode([{
    "image" : "calculator",
    "name" : "calculator",
    "networkMode" : "awsvpc",
    "portMappings" : [{
      "containerPort" : 3000,
      "hostPort" : 3000
    }]

  }])

}