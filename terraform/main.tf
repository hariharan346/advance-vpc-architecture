terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# ======================================================
# VPCs
# ======================================================

# Production VPC
resource "aws_vpc" "prod_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "prod-vpc"
  }
}

# Development VPC
resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev-vpc"
  }
}

# ======================================================
# VPC PEERING
# ======================================================

resource "aws_vpc_peering_connection" "prod_dev_peer" {
  peer_vpc_id = aws_vpc.dev_vpc.id
  vpc_id      = aws_vpc.prod_vpc.id
  auto_accept = true

  tags = {
    Name = "prod-dev-peer"
  }
}

# ======================================================
# SUBNETS
# ======================================================

# Production Public Subnet 1
resource "aws_subnet" "prod_public_1" {
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "prod-public-1"
  }
}

# Production Public Subnet 2
resource "aws_subnet" "prod_public_2" {
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "prod-public-2"
  }
}

# Production Private App Subnet 1
resource "aws_subnet" "prod_private_app_1" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "prod-private-app-1"
  }
}

# Production Private App Subnet 2
resource "aws_subnet" "prod_private_app_2" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "prod-private-app-2"
  }
}

# Production Private DB Subnet
resource "aws_subnet" "prod_private_db" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "prod-private-db"
  }
}

# Development Public Subnet
resource "aws_subnet" "dev_public" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-public-a"
  }
}

# Development Private Subnet
resource "aws_subnet" "dev_private" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = "10.1.11.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "dev-private-a"
  }
}

# ======================================================
# GATEWAYS
# ======================================================

# Prod Internet Gateway
resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "prod-igw"
  }
}

# Dev Internet Gateway
resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

# Prod NAT Gateway EIP
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# Prod NAT Gateway
resource "aws_nat_gateway" "prod_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.prod_public_1.id

  tags = {
    Name = "prod-nat"
  }
}

# ======================================================
# ROUTE TABLES & ASSOCIATIONS
# ======================================================

# Prod Public Route Table
resource "aws_route_table" "prod_public_rt" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_igw.id
  }

  route {
    cidr_block                = "10.1.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.prod_dev_peer.id
  }

  tags = {
    Name = "prod-public-rt"
  }
}

resource "aws_route_table_association" "prod_public_1" {
  subnet_id      = aws_subnet.prod_public_1.id
  route_table_id = aws_route_table.prod_public_rt.id
}

resource "aws_route_table_association" "prod_public_2" {
  subnet_id      = aws_subnet.prod_public_2.id
  route_table_id = aws_route_table.prod_public_rt.id
}

# Prod Private Route Table
resource "aws_route_table" "prod_private_rt" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.prod_nat.id
  }

  route {
    cidr_block                = "10.1.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.prod_dev_peer.id
  }

  tags = {
    Name = "prod-private-rt"
  }
}

resource "aws_route_table_association" "prod_private_app_1" {
  subnet_id      = aws_subnet.prod_private_app_1.id
  route_table_id = aws_route_table.prod_private_rt.id
}

resource "aws_route_table_association" "prod_private_app_2" {
  subnet_id      = aws_subnet.prod_private_app_2.id
  route_table_id = aws_route_table.prod_private_rt.id
}

resource "aws_route_table_association" "prod_private_db" {
  subnet_id      = aws_subnet.prod_private_db.id
  route_table_id = aws_route_table.prod_private_rt.id
}

# Dev Route Table
resource "aws_route_table" "dev_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }

  route {
    cidr_block                = "10.0.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.prod_dev_peer.id
  }

  tags = {
    Name = "dev-rt"
  }
}

resource "aws_route_table_association" "dev_public" {
  subnet_id      = aws_subnet.dev_public.id
  route_table_id = aws_route_table.dev_rt.id
}

# ======================================================
# SECURITY GROUPS
# ======================================================

# Bastion SG
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security Group for Bastion Host"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

# ALB SG
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Application Load Balancer SG"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# App SG
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Application Server SG"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-sg"
  }
}

# DB SG
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Database Security Group"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}

# Dev SG
resource "aws_security_group" "dev_sg" {
  name        = "dev-sg"
  description = "Development EC2 Security Group"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", "10.1.0.0/16"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-sg"
  }
}

# Tools SG
resource "aws_security_group" "tools_sg" {
  name        = "tools-sg"
  description = "Tools Server SG"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tools-sg"
  }
}

# ======================================================
# EC2 INSTANCES
# ======================================================

# Bastion Host
resource "aws_instance" "bastion" {
  ami                    = "ami-0b910d1016287a5e7"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.prod_public_1.id
  key_name               = "enterprise-key"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion-host"
  }
}

# App Server 1
resource "aws_instance" "app_1" {
  ami                    = "ami-0b910d1016287a5e7"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.prod_private_app_1.id
  key_name               = "enterprise-key"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "app-server-1"
  }
}

# App Server 2
resource "aws_instance" "app_2" {
  ami                    = "ami-0b910d1016287a5e7"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.prod_private_app_2.id
  key_name               = "enterprise-key"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "app-server-2"
  }
}

# DB Server
resource "aws_instance" "db" {
  ami                    = "ami-0b910d1016287a5e7"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.prod_private_db.id
  key_name               = "enterprise-key"
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    Name = "db-server"
  }
}

# Dev Server
resource "aws_instance" "dev" {
  ami                    = "ami-0b910d1016287a5e7"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.dev_public.id
  key_name               = "enterprise-key"
  vpc_security_group_ids = [aws_security_group.dev_sg.id]

  tags = {
    Name = "dev-server"
  }
}

# Tools Server
resource "aws_instance" "tools" {
  ami                    = "ami-0b910d1016287a5e7"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.dev_public.id
  key_name               = "enterprise-key"
  vpc_security_group_ids = [aws_security_group.tools_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker
              systemctl enable --now docker
              usermod -aG docker ec2-user
              EOF
  )

  tags = {
    Name = "tools-server"
  }
}

# ======================================================
# LOAD BALANCER & TARGET GROUPS
# ======================================================

# Load Balancer
resource "aws_lb" "prod_alb" {
  name               = "prod-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.prod_public_1.id, aws_subnet.prod_public_2.id]

  tags = {
    Name = "prod-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.prod_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Target Group Attachments
resource "aws_lb_target_group_attachment" "app_1" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "app_2" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_2.id
  port             = 80
}

# ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.prod_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
