output "vpc_id" {
    value = "${module.my_vpc.vpc_id}"
}

output "vpc_cidr_block" {
    value = "${module.my_vpc.vpc_cidr_block}"
}

output "aws_region" {
  value = jsondecode((data.aws_s3_object.config.body)).aws_region
}

output "cluster_name" {
  value = "${local.cluster_name}"
}