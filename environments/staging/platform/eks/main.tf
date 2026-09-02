data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "staging/platform/networking/terraform.tfstate"
    region = var.aws_region
  }
}

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "platform_admin_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:developer-experience-DevEX-platform@321499918/platform-infrastructure@1348443500:ref:refs/heads/main"]
    }
  }

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:user/Temitope"]
    }
  }
}

module "eks" {
  source = "../../../../modules/aws/eks"

  cluster_name       = "devex-staging"
  kubernetes_version = "1.36"

  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnet_ids

  endpoint_private_access = true
  endpoint_public_access  = true

  # Staging temporarily permits public IPv4 access because a restricted
  # corporate egress CIDR is not yet available. Production must use a
  # stricter endpoint policy.
  public_access_cidrs = ["0.0.0.0/0"]

  node_instance_types = ["t3.medium"]
  node_capacity_type  = "ON_DEMAND"
  node_min_size       = 2
  node_desired_size   = 2
  node_max_size       = 4
  node_disk_size      = 30

  tags = {
    Environment = "staging"
  }
}

resource "aws_iam_role" "platform_admin" {
  name               = "devex-staging-eks-admin"
  assume_role_policy = data.aws_iam_policy_document.platform_admin_assume_role.json

  tags = {
    Environment = "staging"
    ManagedBy   = "Terraform"
    Platform    = "DevEx"
    Purpose     = "EKSPlatformAdministration"
  }
}

data "aws_iam_policy_document" "platform_admin" {
  statement {
    sid = "DescribeStagingCluster"

    actions = [
      "eks:DescribeCluster",
    ]

    resources = [module.eks.cluster_arn]
  }
}

resource "aws_iam_role_policy" "platform_admin" {
  name   = "eks-cluster-discovery"
  role   = aws_iam_role.platform_admin.id
  policy = data.aws_iam_policy_document.platform_admin.json
}

resource "aws_eks_access_entry" "platform_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.platform_admin.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "platform_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.platform_admin.arn
  policy_arn    = "arn:${data.aws_partition.current.partition}:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.platform_admin]
}
