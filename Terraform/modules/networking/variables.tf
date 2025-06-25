## networking/variables.tf
variable "vpc_cidr" {}
variable "vpc_region" {}
variable "project_name" {}
variable "num_of_subnets" {}
variable "security_groups_name" {}
variable "allowed_ips" {}
variable "sg_ingress_ports" {}
variable "rt_cidr_block" {}


locals {
  azs = data.aws_availability_zones.az.names
}
data "aws_availability_zones" "az" {
  state = "available"
}

