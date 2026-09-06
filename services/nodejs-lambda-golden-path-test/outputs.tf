output "lambda_release_role_arn" {
  description = "ARN of the GitHub OIDC role that publishes Lambda artifacts."
  value       = module.lambda_release.lambda_release_role_arn
}

output "lambda_artifact_bucket_name" {
  description = "Name of the shared Lambda artifact bucket."
  value       = module.lambda_release.lambda_artifact_bucket_name
}

output "lambda_artifact_prefix" {
  description = "S3 prefix reserved for this service's immutable artifacts."
  value       = module.lambda_release.lambda_artifact_prefix
}
