## Root/variables.tf
variable "vpc_cidr" {}
variable "vpc_region" {}
variable "project_name" {}
variable "num_of_subnets" {}
variable "security_groups_name" {}
variable "sg_ingress_ports" {}
variable "rt_cidr_block" {}



#ALB
variable "alb_name" {}
variable "alb_type" {}
variable "aws_lb_listener_port_https" {}
variable "aws_lb_listener_port_http" {}
variable "aws_lb_listener_protocol_https" {}
variable "aws_lb_listener_protocol_http" {}
variable "allowed_ips" {}
variable "target_group_name" {}
variable "target_group_port" {}
variable "target_group_protocol" {}
variable "target_group_type" {}
variable "listener_forward" {}
variable "listener_path_pattern" {}
variable "alb_health_check_path" {}
variable "alb_health_check_protocol" {}
variable "alb_health_check_matcher" {}
variable "alb_health_check_interval" {}
variable "alb_health_check_timeout" {}
variable "alb_health_check_healthy_threshold" {}
variable "alb_health_check_unhealthy_threshold" {}
# variable "aws_lb_listener_port_http" {}

##ECS
variable "cluster_name" {}
variable "task_definition_name" {}
variable "ecs_launch_type" {}
variable "task_network_mode" {}
variable "ecs_definition_cpu" {}
variable "ecs_definition_memory" {}
variable "ecs_container_name" {}
variable "ecs_container_image_uri" {}
variable "ecs_container_cpu" {}
variable "ecs_container_memory" {}
variable "ecs_container_port" {}
variable "ecs_container_host_port" {}
variable "ecs_service_name" {}
variable "ecs_service_count" {}
variable "ecs_public" {}
variable "ecs_service_launch_type" {}
variable "ecs_iam_role_name" {}
variable "aws_iam_role_policy" {}

##R53
