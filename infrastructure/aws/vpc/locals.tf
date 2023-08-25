resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  common_tags = {
    company = var.company
    project = var.project
  }
  name_prefix = "${var.project}-${var.env_name}"
  cluster_name = "${var.company}-eks-${random_string.suffix.result}"
}