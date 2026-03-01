# PROVIDERS
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

# DATA
# Amazon Machine Image to use
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Availability zones
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
data "aws_availability_zones" "available" {
  state = "available"
}

# RESOURCES

# NETWORKING #

# Here aws_vpc is the resource type and vpc is our arbitrary identifier
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.vpc_enable_dns_hostnames

  tags = local.common_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = local.common_tags
}

resource "aws_subnet" "subnet1" {
  cidr_block              = var.subnet_cidr_block[0]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.subnet_map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = local.common_tags
}

resource "aws_subnet" "subnet2" {
  cidr_block              = var.subnet_cidr_block[1]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.subnet_map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = local.common_tags
}

# ROUTING #
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.route_table_to_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "rta-subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "rta-subnet2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rtb.id
}

# SECURITY GROUPS #

resource "aws_security_group" "nginx-sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = var.sg_ingress_tcp_port
    to_port     = var.sg_ingress_tcp_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # SSH access from anywhere (for fast debugging. Better only from my ip)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.sg_ingress_cidr_block
  }

  # outbound internet access
  egress {
    from_port   = var.sg_egress_tcp_port
    to_port     = var.sg_egress_tcp_port
    protocol    = "-1"
    cidr_blocks = var.sg_egress_cidr_block
  }

  tags = local.common_tags
}

resource "aws_security_group" "lb_sg" {
  name   = "nginx_alb_sg"
  vpc_id = aws_vpc.vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = var.sg_ingress_tcp_port
    to_port     = var.sg_ingress_tcp_port
    protocol    = "tcp"
    cidr_blocks = var.sg_ingress_cidr_block
  }

  # outbound internet access
  egress {
    from_port   = var.sg_egress_tcp_port
    to_port     = var.sg_egress_tcp_port
    protocol    = "-1"
    cidr_blocks = var.sg_egress_cidr_block
  }

  tags = local.common_tags
}
