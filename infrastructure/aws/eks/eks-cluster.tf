data "aws_vpc" "selected" {
  cidr_block = var.vpc_cidr_block
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  tags = {
    Tier = "Private"
  }
}

data "aws_eks_cluster" "eks" {
  depends_on = [module.eks.cluster_id]
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  depends_on = [module.eks.cluster_id]
  name = module.eks.cluster_name
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.10.0"
  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version
  vpc_id          = data.aws_vpc.selected.id
  subnet_ids      = data.aws_subnets.private.ids

  cluster_endpoint_private_access = false
  cluster_endpoint_public_access = true
  
  enable_irsa = true
  
  tags = {
    Environment = var.env_name
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  eks_managed_node_group_defaults = {
      ami_type               = "AL2_x86_64"
      instance_types         = ["t3.medium"]
      vpc_security_group_ids = [aws_security_group.all_nodes_mgmt.id]
  }

  eks_managed_node_groups = {
    
    group_1 = {
      min_size     = 0
      max_size     = 6
      desired_size = 2
      instance_types = ["t3.medium"]
    }

    group_2 = {
      min_size     = 0
      max_size     = 6
      desired_size = 2
      instance_types = ["t3.medium"]
    }
  }
}
