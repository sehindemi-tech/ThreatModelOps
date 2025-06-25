variable "alb_name" {}
variable "alb_type" {}
variable "subnet_id" {}
variable "aws_lb_listener_port_https" {}
variable "aws_lb_listener_protocol_https" {}
variable "alb_sg" {}
variable "target_group_name" {}
variable "target_group_port" {}
variable "target_group_protocol" {}
variable "target_group_type" {}
variable "vpc_id" {}
variable "listener_path_pattern" {}
variable "listener_forward" {}
variable "alb_health_check_path" {}
variable "alb_health_check_protocol" {}
variable "alb_health_check_matcher" {}
variable "alb_health_check_interval" {}
variable "alb_health_check_timeout" {}
variable "alb_health_check_healthy_threshold" {}
variable "alb_health_check_unhealthy_threshold" {}
variable "certificate_arn" {

}
variable "aws_lb_listener_port_http" {

}
variable "aws_lb_listener_protocol_http" {

}