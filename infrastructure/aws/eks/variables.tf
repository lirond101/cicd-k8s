variable "AWS_ACCESS_KEY_ID" {}

variable "AWS_SECRET_ACCESS_KEY" {}

variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
}

variable "env_name" {
  type        = string
  description = "Name of environment it run on"
}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "opsschool"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
}

variable "key_name" {
  type        = string
  description = "key variable for refrencing"
  default     = "kandulaKey"
}

variable "ssh_base_path" {
  type        = string
  description = "Base path for referencing ssh files"
  default     = "/home/ec2-user/.ssh"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
}

# variable "public_subnets" {
#   type = list(string)
#   description = "Desired public_subnets as list of strings"
# }

# variable "private_subnets" {
#   type = list(string)
#   description = "Desired private_subnets as list of strings"
# }

# variable "availability_zone" {
#   type = list(string)
#   description = "Desired AZs as list of strings"
# }

variable "s3_bucket_name" {
  type = string
  description = "Name of the S3 bucket to create"
  default = "kandula-opsschool-lirondadon"
}

variable "kubernetes_version" {
  default = 1.24
  description = "kubernetes version"
}

variable "common_tags" {
  type        = map(string)
  description = "Map of tags to be applied to all resources"
  default     = {}
}