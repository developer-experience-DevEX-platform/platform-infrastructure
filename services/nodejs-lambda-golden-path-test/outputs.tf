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

output "staging_function_name" {
  description = "Name of the staging Lambda function."
  value       = module.lambda_release.staging_function_name
}

output "staging_function_arn" {
  description = "ARN of the staging Lambda function."
  value       = module.lambda_release.staging_function_arn
}

output "staging_execution_role_arn" {
  description = "ARN of the staging Lambda execution role."
  value       = module.lambda_release.staging_execution_role_arn
}

output "staging_deploy_role_arn" {
  description = "ARN of the future GitHub staging deployment role."
  value       = module.lambda_release.staging_deploy_role_arn
}

output "staging_log_group_name" {
  description = "Name of the staging Lambda CloudWatch log group."
  value       = module.lambda_release.staging_log_group_name
}
