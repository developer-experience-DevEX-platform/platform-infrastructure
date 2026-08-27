terraform {
  backend "azurerm" {
    resource_group_name  = "Backstage-workflow"
    storage_account_name = "devexplatformtfstate"
    container_name       = "tfstate"
    key                  = "dev/services/catalog-api.tfstate"
    use_azuread_auth     = true
  }
}
