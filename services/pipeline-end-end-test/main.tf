module "container_release" {
  source = "../../modules/platform/service-container-release"

  service_name             = var.service_name
  github_owner             = var.github_owner
  github_owner_id          = var.github_owner_id
  github_repository        = var.github_repository
  github_repository_id     = var.github_repository_id
  github_oidc_provider_arn = var.github_oidc_provider_arn
  aws_region               = var.aws_region

  tags = {
    Scope = "shared"
  }
}
