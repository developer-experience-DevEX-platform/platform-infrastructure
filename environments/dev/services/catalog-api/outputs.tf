output "ecr_repository_name" {
  description = "ECR repository name for the service."
  value       = module.container_release.ecr_repository_name
}

output "ecr_repository_url" {
  description = "Full ECR repository URL for the service."
  value       = module.container_release.ecr_repository_url
}

output "release_role_arn" {
  description = "ARN of the service GitHub Actions release role."
  value       = module.container_release.release_role_arn
}
