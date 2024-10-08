output "load_balancer_dns_name" {
  value       = aws_lb.load_balancer.dns_name
}

output "target_group_arn" {
  value       = aws_lb_target_group.tg.arn
}

output "alb_arn" {
  value       = aws_lb.load_balancer.arn
}
