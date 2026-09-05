output "lambda_release_role_name" {
  description = "Name of the GitHub OIDC role that publishes Lambda artifacts."
  value       = aws_iam_role.lambda_release.name
}

output "lambda_release_role_arn" {
  description = "ARN of the GitHub OIDC role that publishes Lambda artifacts."
  value       = aws_iam_role.lambda_release.arn
}

output "lambda_artifact_bucket_name" {
  description = "Name of the shared Lambda artifact bucket."
  value       = var.lambda_artifact_bucket_name
}

output "lambda_artifact_prefix" {
  description = "S3 prefix reserved for this service."
  value       = local.artifact_prefix
}
