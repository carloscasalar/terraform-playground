# COMMON
variable "company" {
  description = "Company name for resource tagging"
  type        = string
  default     = "ACME"
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
}

variable "billing_code" {
  description = "Billing code for resource tagging"
  type        = string
}

# PROVIDERS
variable "aws_access_key" {
  description = "AWS access key for Terraform"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key for Terraform"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region to use for resources"
  default     = "eu-north-1"
  type        = string
}

# Networking
variable "vpc_cidr_block" {
  description = "CIDR Block of VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_enable_dns_hostnames" {
  description = "Enable/disable DNS on VPC"
  type        = bool
  default     = true
}

variable "subnet_cidr_block" {
  description = "CIDR Block of Subnet"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "subnet_map_public_ip_on_launch" {
  description = "Instances launched assign public IP"
  type        = bool
  default     = true
}

# ROUTING
variable "route_table_to_cidr_block" {
  description = "IPs to redirect to the internet by default all(because we have a gateway)"
  type        = string
  default     = "0.0.0.0/0"
}

# SECURITY GROUPS
variable "sg_ingress_cidr_block" {
  description = "CIDR Blocks for ingress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "sg_ingress_tcp_port" {
  description = "Ingress port for TCP"
  type        = number
  default     = 80
}

variable "sg_egress_cidr_block" {
  description = "CIDR Blocks for egress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "sg_egress_tcp_port" {
  description = "egress port for TCP"
  type        = number
  default     = 0
}

# INSTANCE
variable "aws_instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t3.micro"
}
