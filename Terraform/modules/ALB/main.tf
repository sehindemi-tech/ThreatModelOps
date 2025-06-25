# Alb/main

resource "aws_lb" "threat-composer-lb" {
  name                       = var.alb_name
  internal                   = false
  load_balancer_type         = var.alb_type
  security_groups            = var.alb_sg
  subnets                    = var.subnet_id
  enable_deletion_protection = false
  tags = {
    Name = "production"
  }
}

resource "aws_lb_target_group" "threat-composer-tg" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = var.target_group_type
  vpc_id      = var.vpc_id
  health_check {
    path                = var.alb_health_check_path
    protocol            = var.alb_health_check_protocol
    matcher             = var.alb_health_check_matcher
    interval            = var.alb_health_check_interval
    timeout             = var.alb_health_check_timeout
    healthy_threshold   = var.alb_health_check_healthy_threshold
    unhealthy_threshold = var.alb_health_check_unhealthy_threshold
  }
}

resource "aws_lb_listener" "threat-composer-listner" {
  load_balancer_arn = aws_lb.threat-composer-lb.arn
  port              = var.aws_lb_listener_port_https
  protocol          = var.aws_lb_listener_protocol_https
  certificate_arn   = var.certificate_arn
  default_action {
    type             = var.listener_forward
    target_group_arn = aws_lb_target_group.threat-composer-tg.arn
  }
}
resource "aws_lb_listener" "threat-composer-listner_http" {
  load_balancer_arn = aws_lb.threat-composer-lb.arn
  port              = var.aws_lb_listener_port_http
  protocol          = var.aws_lb_listener_protocol_http
  default_action {
    type = "redirect"
    redirect {
      port        = var.aws_lb_listener_port_https
      protocol    = var.aws_lb_listener_protocol_https
      status_code = "HTTP_301"
    }
  }
}
