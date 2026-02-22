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
