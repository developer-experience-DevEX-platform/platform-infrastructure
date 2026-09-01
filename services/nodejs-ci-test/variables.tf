variable "aws_region" {
  description = "AWS region for the service container-release infrastructure."
  type        = string
}

variable "github_owner" {
  description = "GitHub organization that owns the service repository."
  type        = string
  default     = "developer-experience-DevEX-platform"
}

variable "github_owner_id" {
  description = "Immutable numeric ID of the GitHub organization."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository receiving the platform-managed release variables."
  type        = string
  default     = "nodejs-ci-test"
}

variable "github_repository_id" {
  description = "Immutable numeric ID of the GitHub service repository."
  type        = string
}

variable "github_oidc_provider_arn" {
  description = "ARN of the existing account-level GitHub Actions OIDC provider."
  type        = string
}

variable "service_name" {
  description = "Platform service name."
  type        = string
  default     = "nodejs-ci-test"

  validation {
    condition     = can(regex("^[a-z0-9]+(?:-[a-z0-9]+)*$", var.service_name))
    error_message = "service_name must use lowercase kebab-case, for example nodejs-ci-test."
  }
}
