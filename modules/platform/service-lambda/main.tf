data "aws_partition" "current" {}

locals {
  artifact_bucket_arn = "arn:${data.aws_partition.current.partition}:s3:::${var.lambda_artifact_bucket_name}"
  artifact_prefix     = "${var.service_name}/"

  tags = merge(
    {
      ManagedBy = "Terraform"
      Platform  = "DevEx"
      Service   = var.service_name
    },
    var.tags,
  )
}

data "aws_iam_policy_document" "lambda_release_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.github_oidc_provider_arn]
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

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:job_workflow_ref"
      values   = ["developer-experience-DevEX-platform/ci-cd-templates/.github/workflows/nodejs-lambda-release.yml@refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "lambda_release" {
  name               = "${var.service_name}-github-lambda-release"
  assume_role_policy = data.aws_iam_policy_document.lambda_release_assume_role.json
  tags               = local.tags
}

data "aws_iam_policy_document" "lambda_artifacts" {
  statement {
    sid       = "ListServiceArtifactPrefix"
    actions   = ["s3:ListBucket"]
    resources = [local.artifact_bucket_arn]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["${local.artifact_prefix}*"]
    }
  }

  statement {
    sid = "PublishServiceArtifacts"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = ["${local.artifact_bucket_arn}/${local.artifact_prefix}*"]
  }
}

resource "aws_iam_role_policy" "lambda_artifacts" {
  name   = "${var.service_name}-lambda-artifact-release"
  role   = aws_iam_role.lambda_release.id
  policy = data.aws_iam_policy_document.lambda_artifacts.json
}

resource "github_actions_variable" "aws_region" {
  repository    = var.github_repository
  variable_name = "AWS_REGION"
  value         = var.aws_region
}

resource "github_actions_variable" "aws_lambda_release_role_arn" {
  repository    = var.github_repository
  variable_name = "AWS_LAMBDA_RELEASE_ROLE_ARN"
  value         = aws_iam_role.lambda_release.arn
}

resource "github_actions_variable" "aws_lambda_artifact_bucket" {
  repository    = var.github_repository
  variable_name = "AWS_LAMBDA_ARTIFACT_BUCKET"
  value         = var.lambda_artifact_bucket_name
}
