variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the existing subnet"
  type        = string
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "my-ec2-server"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "my-ec2-key"
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "development"
}

variable "private_ip" {
  description = "Private IP address for the instance (optional)"
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH into the instance"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20
}