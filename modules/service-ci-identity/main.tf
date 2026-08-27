resource "azurerm_user_assigned_identity" "ci" {
  name                = "${var.service_name}-ci"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_federated_identity_credential" "github" {
  name                = "${var.service_name}-github-${var.github_branch}"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.ci.id
  issuer              = "https://token.actions.githubusercontent.com"
  audience            = ["api://AzureADTokenExchange"]
  subject             = "repo:${var.github_owner}@${var.github_owner_id}/${var.github_repository}@${var.github_repository_id}:ref:refs/heads/${var.github_branch}"
}

resource "azurerm_role_assignment" "acr_push" {
  scope                = var.acr_id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.ci.principal_id
  principal_type       = "ServicePrincipal"
}
