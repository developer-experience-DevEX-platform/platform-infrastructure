output "terraform_state_bucket_name" {
  description = "Name of the Terraform remote-state S3 bucket."
  value       = aws_s3_bucket.terraform_state.id
}

output "github_oidc_provider_arn" {
  description = "ARN of the account-level GitHub Actions OIDC provider."
  value       = aws_iam_openid_connect_provider.github_actions.arn
}

output "terraform_execution_role_name" {
  description = "Name of the company infrastructure Terraform execution role."
  value       = aws_iam_role.terraform_platform.name
}

output "terraform_execution_role_arn" {
  description = "ARN of the company infrastructure Terraform execution role."
  value       = aws_iam_role.terraform_platform.arn
}

output "terraform_plan_role_name" {
  description = "Name of the read-only pull-request Terraform plan role."
  value       = aws_iam_role.terraform_plan.name
}

output "terraform_plan_role_arn" {
  description = "ARN of the read-only pull-request Terraform plan role."
  value       = aws_iam_role.terraform_plan.arn
}
