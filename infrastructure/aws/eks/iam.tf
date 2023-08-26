data "aws_iam_policy" "aws_load_balancer_controller_policy" {
  arn = "arn:aws:iam::902770729603:policy/AWSLoadBalancerControllerIAMPolicy"
}

module "alb_iam-assumable-role-with-oidc" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.13.0"
  create_role                   = true
  role_name                     = "aws-load-balancer-controller-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [data.aws_iam_policy.aws_load_balancer_controller_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
}