variable "service_name" {
  description = "Platform service name and S3 artifact prefix."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(?:-[a-z0-9]+)*$", var.service_name))
    error_message = "service_name must use lowercase kebab-case."
  }
}

variable "github_owner" {
  description = "GitHub organization that owns the service repository."
  type        = string
}

variable "github_owner_id" {
  description = "Immutable numeric GitHub organization ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9]+$", var.github_owner_id))
    error_message = "github_owner_id must contain only digits."
  }
}

variable "github_repository" {
  description = "GitHub service repository allowed to publish Lambda artifacts."
  type        = string
}

variable "github_repository_id" {
  description = "Immutable numeric GitHub repository ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9]+$", var.github_repository_id))
    error_message = "github_repository_id must contain only digits."
  }
}

variable "github_branch" {
  description = "Branch allowed to publish Lambda release artifacts."
  type        = string
  default     = "main"
}

variable "github_oidc_provider_arn" {
  description = "ARN of the existing account-level GitHub Actions OIDC provider."
  type        = string
}

variable "aws_region" {
  description = "AWS region used by Lambda release workflows."
  type        = string
}

variable "lambda_artifact_bucket_name" {
  description = "Name of the shared platform-owned Lambda artifact bucket."
  type        = string
}

variable "tags" {
  description = "Additional tags for service-owned IAM resources."
  type        = map(string)
  default     = {}
}
