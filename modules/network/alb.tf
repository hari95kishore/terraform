# alb security group
resource "aws_security_group" "alb-sg" {
  name   = "elopage-alb-security-group"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "elopage_alb" {
  name               = "${var.service_name}-alb"
  internal           = var.public_facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = module.vpc.public_subnets
  idle_timeout       = 300
}

resource "aws_lb_target_group" "elopage_alb_tg" {
  name        = "${var.service_name}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
}


resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.elopage_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.elopage_alb_tg.arn
    type             = "forward"
  }
}