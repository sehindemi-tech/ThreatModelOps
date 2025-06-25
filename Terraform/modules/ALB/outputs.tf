output "target_group_arn" {
  value = aws_lb_target_group.threat-composer-tg.arn
}

output "alb_dns_name" {
  value = aws_lb.threat-composer-lb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.threat-composer-lb.zone_id
}