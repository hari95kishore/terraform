output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "alb-sg-id" {
  value = aws_security_group.alb-sg.id
}

output "alb-tg-arn" {
  value = aws_lb_target_group.elopage_alb_tg.arn
}

output "alb-arn-suffix" {
  value = aws_lb.elopage_alb.arn_suffix
}

output "tg-arn-suffix" {
  value = aws_lb_target_group.elopage_alb_tg.arn_suffix
}