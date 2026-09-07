data "terraform_remote_state" "bootstrap" {
  backend = "s3"

  config = {
    bucket       = var.terraform_state_bucket
    key          = "bootstrap/aws-account/terraform.tfstate"
    region       = var.aws_region
    use_lockfile = true
  }
}

module "lambda_release" {
  source = "../../modules/platform/service-lambda"

  service_name                = var.service_name
  github_owner                = var.github_owner
  github_owner_id             = var.github_owner_id
  github_repository           = var.github_repository
  github_repository_id        = var.github_repository_id
  github_oidc_provider_arn    = var.github_oidc_provider_arn
  aws_region                  = var.aws_region
  lambda_artifact_bucket_name = data.terraform_remote_state.bootstrap.outputs.lambda_artifact_bucket_name
  initial_artifact_key        = "nodejs-lambda-golden-path-test/f2be832527f733af0617f591626bfdbb22006639/function.zip"

  tags = {
    Scope = "shared"
  }
}
