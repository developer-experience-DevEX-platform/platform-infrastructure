module "service_ci_identity" {
  source = "../../../../modules/service-ci-identity"

  service_name         = "inventory-api"
  github_owner         = "developer-experience-DevEX-platform"
  github_owner_id      = "321499918"
  github_repository    = "inventory-api"
  github_repository_id = "1348610000"
  github_branch        = "main"

  resource_group_name = var.resource_group_name
  location            = var.location
  acr_id              = var.acr_id
}
