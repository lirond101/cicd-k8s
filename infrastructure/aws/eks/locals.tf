data "aws_s3_object" "cluster_name" {
  bucket = var.s3_bucket_name
  key    = "cluster_name"
}

locals {
  common_tags = {
    company = var.company
    project = var.project
  }
  name_prefix = "${var.project}-${var.env_name}"
  cluster_name = tostring(data.aws_s3_object.cluster_name.body)
  # k8s_service_account_namespace = "kandula"
  # k8s_service_account_name      = "opsschool-sa"
}

