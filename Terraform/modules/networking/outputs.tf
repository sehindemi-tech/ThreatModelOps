## networking/variables.tf

output "public_subnets" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "alb_sg" {
  value = [aws_security_group.threat-composer-alb-listner-sg.id]
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}