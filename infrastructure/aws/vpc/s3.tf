# Upload an object
resource "aws_s3_object" "object" {
  bucket = var.s3_bucket_name
  key = "cluster_name"
  content = "${local.cluster_name}"
  content_type = "text/*"
}

data "aws_s3_object" "config" {
  bucket = var.s3_bucket_name
  key = "config.json"
}