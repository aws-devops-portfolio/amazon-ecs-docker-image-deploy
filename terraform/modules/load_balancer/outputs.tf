output "alb_endpoint" {
  value = aws_lb.web_alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.alb_tg.arn
}