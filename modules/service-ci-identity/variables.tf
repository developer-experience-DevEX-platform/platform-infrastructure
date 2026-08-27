variable "service_name" {
  description = "Name of the service that uses the CI identity."
  type        = string
}

variable "github_owner" {
  description = "GitHub organization or account that owns the service repository."
  type        = string
}

variable "github_owner_id" {
  description = "Immutable numeric ID of the GitHub repository owner."
  type        = string
}

variable "github_repository" {
  description = "Name of the GitHub service repository."
  type        = string
}

variable "github_repository_id" {
  description = "Immutable numeric ID of the GitHub service repository."
  type        = string
}

variable "github_branch" {
  description = "Git branch trusted to use the CI identity."
  type        = string
  default     = "main"
}

variable "resource_group_name" {
  description = "Name of the existing resource group for the managed identity."
  type        = string
}

variable "location" {
  description = "Azure region in which to create the managed identity."
  type        = string
}

variable "acr_id" {
  description = "Resource ID of the existing Azure Container Registry."
  type        = string
}
