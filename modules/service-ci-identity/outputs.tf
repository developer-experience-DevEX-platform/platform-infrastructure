output "client_id" {
  description = "Client ID of the CI managed identity."
  value       = azurerm_user_assigned_identity.ci.client_id
}

output "principal_id" {
  description = "Principal ID of the CI managed identity."
  value       = azurerm_user_assigned_identity.ci.principal_id
}

output "identity_id" {
  description = "Azure resource ID of the CI managed identity."
  value       = azurerm_user_assigned_identity.ci.id
}
