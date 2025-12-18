terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}

# Create VPC
resource "aws_vpc" "datacenter_priv_vpc" {
  cidr_block           = var.KKE_VPC_CIDR
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "datacenter-priv-vpc"
  }
}

# Create subnet with auto-assign IP disabled
resource "aws_subnet" "datacenter_priv_subnet" {
  vpc_id                  = aws_vpc.datacenter_priv_vpc.id
  cidr_block              = var.KKE_SUBNET_CIDR
  map_public_ip_on_launch = false

  tags = {
    Name = "datacenter-priv-subnet"
  }
}

# Create security group allowing only VPC CIDR access
resource "aws_security_group" "datacenter_priv_sg" {
  name        = "datacenter-priv-sg"
  description = "Security group allowing access only from within the VPC"
  vpc_id      = aws_vpc.datacenter_priv_vpc.id

  # Allow all inbound traffic from within the VPC
  ingress {
    description = "Allow all traffic from VPC CIDR"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.KKE_VPC_CIDR]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "datacenter-priv-sg"
  }
}

# Create EC2 instance
resource "aws_instance" "datacenter_priv_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.datacenter_priv_subnet.id
  vpc_security_group_ids = [aws_security_group.datacenter_priv_sg.id]

  tags = {
    Name = "datacenter-priv-ec2"
  }
}
