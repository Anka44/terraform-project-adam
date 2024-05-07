terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region_name
}
resource "aws_instance" "app_server" {

  ami           = "ami-07d95467596b97099"
  instance_type = "t2.micro"

}


resource "aws_vpc" "customVPC" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.customVPC.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az1
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.customVPC.id
  cidr_block              = var.subnet2_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az2
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.customVPC.id
}

resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.customVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_subnet_association1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.publicRT.id
}

resource "aws_route_table_association" "public_subnet_association2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.publicRT.id
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.customVPC.id

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
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.customVPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "web_alb" {
  name               = "adamapp-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]

  tags = {
    Environment = "lab"
  }
}

output "lb_dns_name" {
  value = aws_lb.web_alb.dns_name
}
