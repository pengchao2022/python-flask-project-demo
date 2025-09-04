terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Get the latest Ubuntu 20.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Create SSH key pair
resource "tls_private_key" "ubuntu_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ubuntu_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ubuntu_key.public_key_openssh
}

# Save private key to file
resource "local_file" "private_key" {
  content         = tls_private_key.ubuntu_key.private_key_pem
  filename        = "${var.key_name}.pem"
  file_permission = "0400"
}

# Create security group for the Ubuntu instance
resource "aws_security_group" "ubuntu_private_sg" {
  name        = "${var.instance_name}-sg"
  description = "Security group for ${var.instance_name}"
  vpc_id      = var.vpc_id

  # SSH access from private networks only
  ingress {
    description = "SSH from private networks"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.instance_name}-sg"
    Environment = var.environment
    Instance    = var.instance_name
  }
}

# Create Ubuntu instance in private subnet
resource "aws_instance" "ubuntu_private" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ubuntu_key.key_name
  
  # Network configuration
  subnet_id              = var.subnet_id
  private_ip             = var.private_ip != "" ? var.private_ip : null
  vpc_security_group_ids = [aws_security_group.ubuntu_private_sg.id]
  
  # No public IP address
  associate_public_ip_address = false

  tags = {
    Name        = var.instance_name
    Environment = var.environment
    OS          = "Ubuntu 20.04"
    InstanceType = var.instance_type
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true
    
    tags = {
      Name        = "${var.instance_name}-root-volume"
      Environment = var.environment
      Instance    = var.instance_name
    }
  }
}