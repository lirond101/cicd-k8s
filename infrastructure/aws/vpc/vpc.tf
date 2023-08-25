##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

data "aws_s3_bucket" "selected" {
  bucket = var.s3_bucket_name
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #

# vpc
module "my_vpc" {
  source  = "app.terraform.io/opsschool-lirondadon/vpc/aws"
  version = "1.0.1"

  vpc_cidr_block       = var.vpc_cidr_block
  availability_zone    = var.availability_zone
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  enable_dns_hostnames = true
  name_prefix          = local.name_prefix

  common_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  # common_tags = {}

  public_subnet_tags = {
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"             = "1"
  }
}




