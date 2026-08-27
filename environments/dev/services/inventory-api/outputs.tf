# Outputs consumed by the service identity automation pipeline.
output "client_id" {
  description = "Client ID of the service CI managed identity."
  value       = module.service_ci_identity.client_id
}

output "principal_id" {
  description = "Principal ID of the service CI managed identity."
  value       = module.service_ci_identity.principal_id
}

output "identity_id" {
  description = "Azure resource ID of the service CI managed identity."
  value       = module.service_ci_identity.identity_id
}
