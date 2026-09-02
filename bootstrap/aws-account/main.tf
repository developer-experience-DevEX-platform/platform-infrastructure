data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.terraform_state_bucket_name
  force_destroy = false

  tags = {
    ManagedBy = "Terraform"
    Platform  = "DevEx"
    Purpose   = "TerraformState"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  tags = {
    ManagedBy = "Terraform"
    Platform  = "DevEx"
    Purpose   = "GitHubActionsOIDC"
  }
}

data "aws_iam_policy_document" "terraform_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_owner}@${var.github_owner_id}/${var.github_repository}@${var.github_repository_id}:ref:refs/heads/${var.github_branch}"]
    }
  }
}

data "aws_iam_policy_document" "terraform_plan_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_owner}@${var.github_owner_id}/${var.github_repository}@${var.github_repository_id}:pull_request"]
    }
  }
}

resource "aws_iam_role" "terraform_platform" {
  name               = "devex-terraform-platform"
  assume_role_policy = data.aws_iam_policy_document.terraform_assume_role.json

  tags = {
    ManagedBy = "Terraform"
    Platform  = "DevEx"
    Purpose   = "TerraformExecution"
  }
}

resource "aws_iam_role" "terraform_plan" {
  name               = "devex-terraform-plan"
  assume_role_policy = data.aws_iam_policy_document.terraform_plan_assume_role.json

  tags = {
    ManagedBy = "Terraform"
    Platform  = "DevEx"
    Purpose   = "TerraformPlan"
  }
}

data "aws_iam_policy_document" "terraform_platform" {
  statement {
    sid = "ReadEKSInfrastructure"

    actions = [
      "eks:Describe*",
      "eks:List*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "ManageEKSInfrastructure"

    actions = [
      "eks:AssociateAccessPolicy",
      "eks:CreateAccessEntry",
      "eks:CreateAddon",
      "eks:CreateCluster",
      "eks:CreateNodegroup",
      "eks:DeleteAccessEntry",
      "eks:DeleteAddon",
      "eks:DeleteCluster",
      "eks:DeleteNodegroup",
      "eks:DisassociateAccessPolicy",
      "eks:TagResource",
      "eks:UntagResource",
      "eks:UpdateAccessEntry",
      "eks:UpdateAddon",
      "eks:UpdateClusterConfig",
      "eks:UpdateClusterVersion",
      "eks:UpdateNodegroupConfig",
      "eks:UpdateNodegroupVersion",
    ]

    resources = ["*"]
  }

  statement {
    sid = "ManageEKSRoles"

    actions = [
      "iam:AttachRolePolicy",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:DetachRolePolicy",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListRolePolicies",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:UpdateAssumeRolePolicy",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/devex-*-eks-*",
    ]
  }

  statement {
    sid = "PassEKSRoles"

    actions = [
      "iam:PassRole",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/devex-*-eks-*",
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values = [
        "eks.amazonaws.com",
        "ec2.amazonaws.com",
      ]
    }
  }

  statement {
    sid = "CreateEKSServiceLinkedRoles"

    actions = [
      "iam:CreateServiceLinkedRole",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS",
      "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/eks-nodegroup.amazonaws.com/AWSServiceRoleForAmazonEKSNodegroup",
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"
      values = [
        "eks.amazonaws.com",
        "eks-nodegroup.amazonaws.com",
      ]
    }
  }

  statement {
    sid = "ReadEKSNodegroupServiceLinkedRole"

    actions = [
      "iam:GetRole",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/eks-nodegroup.amazonaws.com/AWSServiceRoleForAmazonEKSNodegroup",
    ]
  }

  statement {
    sid = "ReadNetworkInfrastructure"

    actions = [
      "ec2:Describe*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "ManageNetworkInfrastructure"

    actions = [
      "ec2:AllocateAddress",
      "ec2:AssociateRouteTable",
      "ec2:AttachInternetGateway",
      "ec2:CreateInternetGateway",
      "ec2:CreateNatGateway",
      "ec2:CreateRoute",
      "ec2:CreateRouteTable",
      "ec2:CreateSubnet",
      "ec2:CreateTags",
      "ec2:CreateVpc",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteNatGateway",
      "ec2:DeleteRoute",
      "ec2:DeleteRouteTable",
      "ec2:DeleteSubnet",
      "ec2:DeleteTags",
      "ec2:DeleteVpc",
      "ec2:DetachInternetGateway",
      "ec2:DisassociateRouteTable",
      "ec2:ModifySubnetAttribute",
      "ec2:ModifyVpcAttribute",
      "ec2:ReleaseAddress",
      "ec2:ReplaceRoute",
      "ec2:ReplaceRouteTableAssociation",
    ]

    resources = ["*"]
  }

  statement {
    sid = "ManageServiceECRRepositories"
    actions = [
      "ecr:CreateRepository",
      "ecr:DeleteLifecyclePolicy",
      "ecr:DeleteRepository",
      "ecr:DeleteRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetRepositoryPolicy",
      "ecr:ListTagsForResource",
      "ecr:PutImageScanningConfiguration",
      "ecr:PutImageTagMutability",
      "ecr:PutLifecyclePolicy",
      "ecr:SetRepositoryPolicy",
      "ecr:StartLifecyclePolicyPreview",
      "ecr:TagResource",
      "ecr:UntagResource",
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:ecr:*:${data.aws_caller_identity.current.account_id}:repository/*",
    ]
  }

  statement {
    sid = "ManageServiceReleaseRoles"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListRolePolicies",
      "iam:PutRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:UpdateAssumeRolePolicy",
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/*-github-release",
    ]
  }

  statement {
    sid = "ListGitHubOIDCProviders"
    actions = [
      "iam:ListOpenIDConnectProviders",
    ]
    resources = ["*"]
  }

  statement {
    sid = "ReadGitHubOIDCProvider"
    actions = [
      "iam:GetOpenIDConnectProvider",
    ]
    resources = [aws_iam_openid_connect_provider.github_actions.arn]
  }

  statement {
    sid = "ListTerraformStateBucket"
    actions = [
      "s3:ListBucket",
    ]
    resources = [aws_s3_bucket.terraform_state.arn]
  }

  statement {
    sid = "ReadWriteTerraformState"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = ["${aws_s3_bucket.terraform_state.arn}/*"]
  }

  statement {
    sid = "ManageTerraformStateLockFiles"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["${aws_s3_bucket.terraform_state.arn}/*.tflock"]
  }
}

resource "aws_iam_role_policy" "terraform_platform" {
  name   = "devex-terraform-platform"
  role   = aws_iam_role.terraform_platform.id
  policy = data.aws_iam_policy_document.terraform_platform.json
}

data "aws_iam_policy_document" "terraform_plan" {
  statement {
    sid = "ReadEKSInfrastructure"

    actions = [
      "eks:Describe*",
      "eks:List*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "ReadEKSRoles"

    actions = [
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListRolePolicies",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/devex-*-eks-*",
    ]
  }

  statement {
    sid = "ReadNetworkInfrastructure"

    actions = [
      "ec2:Describe*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "ReadECRInfrastructure"
    actions = [
      "ecr:DescribeRepositories",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetRepositoryPolicy",
      "ecr:ListTagsForResource",
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:ecr:*:${data.aws_caller_identity.current.account_id}:repository/*",
    ]
  }

  statement {
    sid = "ReadServiceReleaseRoles"
    actions = [
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/*-github-release",
    ]
  }

  statement {
    sid = "ListGitHubOIDCProviders"
    actions = [
      "iam:ListOpenIDConnectProviders",
    ]
    resources = ["*"]
  }

  statement {
    sid = "ReadGitHubOIDCProvider"
    actions = [
      "iam:GetOpenIDConnectProvider",
    ]
    resources = [aws_iam_openid_connect_provider.github_actions.arn]
  }

  statement {
    sid = "ListTerraformStateBucket"
    actions = [
      "s3:ListBucket",
    ]
    resources = [aws_s3_bucket.terraform_state.arn]
  }

  statement {
    sid = "ReadTerraformState"
    actions = [
      "s3:GetObject",
    ]
    resources = ["${aws_s3_bucket.terraform_state.arn}/*"]
  }

  statement {
    sid = "ManageTerraformStateLockFiles"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["${aws_s3_bucket.terraform_state.arn}/*.tflock"]
  }
}

resource "aws_iam_role_policy" "terraform_plan" {
  name   = "devex-terraform-plan"
  role   = aws_iam_role.terraform_plan.id
  policy = data.aws_iam_policy_document.terraform_plan.json
}
