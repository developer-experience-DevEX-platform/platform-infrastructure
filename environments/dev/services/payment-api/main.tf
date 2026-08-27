module "service_ci_identity" {
  source = "../../../../modules/service-ci-identity"

  service_name         = "payment-api"
  github_owner         = "developer-experience-DevEX-platform"
  github_owner_id      = "321499918"
  github_repository    = "payment-api"
  github_repository_id = "1347924213"
  github_branch        = "main"

  resource_group_name = var.resource_group_name
  location            = var.location
  acr_id              = var.acr_id
}
