## Root/main.tf 

module "networking" {
  source               = "./modules/networking/"
  vpc_cidr             = var.vpc_cidr
  vpc_region           = var.vpc_region
  num_of_subnets       = var.num_of_subnets
  project_name         = var.project_name
  security_groups_name = var.security_groups_name
  allowed_ips          = var.allowed_ips
  sg_ingress_ports     = var.sg_ingress_ports
  rt_cidr_block        = var.rt_cidr_block



}

module "alb" {
  source                               = "./modules/ALB"
  alb_type                             = var.alb_type
  alb_name                             = var.alb_name
  subnet_id                            = module.networking.public_subnets
  aws_lb_listener_port_https           = var.aws_lb_listener_port_https
  aws_lb_listener_protocol_https       = var.aws_lb_listener_protocol_https
  aws_lb_listener_protocol_http        = var.aws_lb_listener_protocol_http
  aws_lb_listener_port_http            = var.aws_lb_listener_port_http
  alb_sg                               = module.networking.alb_sg
  vpc_id                               = module.networking.vpc_id
  target_group_name                    = var.target_group_name
  target_group_port                    = var.target_group_port
  target_group_protocol                = var.target_group_protocol
  target_group_type                    = var.target_group_type
  listener_path_pattern                = var.listener_path_pattern
  listener_forward                     = var.listener_forward
  alb_health_check_path                = var.alb_health_check_path
  alb_health_check_healthy_threshold   = var.alb_health_check_healthy_threshold
  alb_health_check_interval            = var.alb_health_check_interval
  alb_health_check_matcher             = var.alb_health_check_matcher
  alb_health_check_protocol            = var.alb_health_check_protocol
  alb_health_check_timeout             = var.alb_health_check_timeout
  alb_health_check_unhealthy_threshold = var.alb_health_check_unhealthy_threshold
  certificate_arn                      = module.R53.acm_arn


}
module "ECS" {
  source                = "./modules/ECS"
  cluster_name          = var.cluster_name
  task_definition_name  = var.task_definition_name
  ecs_launch_type       = var.ecs_launch_type
  task_network_mode     = var.task_network_mode
  ecs_definition_cpu    = var.ecs_definition_cpu
  ecs_definition_memory = var.ecs_definition_memory

  ecs_container_cpu       = var.ecs_container_cpu
  ecs_container_memory    = var.ecs_container_memory
  ecs_container_port      = var.ecs_container_port
  ecs_container_host_port = var.ecs_container_host_port
  ecs_container_image_uri = var.ecs_container_image_uri
  ecs_container_name      = var.ecs_container_name

  public_subnets          = module.networking.public_subnets
  security_groups         = module.networking.alb_sg
  ecs_service_name        = var.ecs_service_name
  ecs_service_count       = var.ecs_service_count
  ecs_public              = var.ecs_public
  target_group_arn        = module.alb.target_group_arn
  ecs_service_launch_type = var.ecs_service_launch_type
  ecs_iam_role_name       = var.ecs_iam_role_name
  aws_iam_role_policy     = var.aws_iam_role_policy

}

module "R53" {
  source       = "./modules/R53"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id

}