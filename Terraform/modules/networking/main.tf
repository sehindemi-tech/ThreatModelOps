## networking/main.tf

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}


resource "aws_subnet" "public_subnets" {
  for_each                = { for i in range(var.num_of_subnets) : "public-subnet${i}" => i }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, each.value)
  availability_zone       = local.azs[each.value % length(local.azs)]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}

resource "aws_internet_gateway" "threat-composer-rt-igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name}"
  }
}

resource "aws_route_table" "threat-composer-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.rt_cidr_block
    gateway_id = aws_internet_gateway.threat-composer-rt-igw.id
  }
}

resource "aws_route_table_association" "threat-composer-rta" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.threat-composer-rt.id
}

resource "aws_security_group" "threat-composer-alb-listner-sg" {
  name   = var.security_groups_name
  vpc_id = aws_vpc.vpc.id
  dynamic "ingress" {
    for_each = var.sg_ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.allowed_ips
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
