variable "terraform_state_bucket_name" {
  description = "Globally unique name for the Terraform remote-state S3 bucket."
  type        = string
}

variable "github_owner" {
  description = "GitHub organization that owns the company infrastructure repository."
  type        = string
}

variable "github_owner_id" {
  description = "Immutable numeric ID of the GitHub organization."
  type        = string
  default     = "321499918"
}

variable "github_repository" {
  description = "Company infrastructure GitHub repository allowed to assume the Terraform execution role."
  type        = string
}

variable "github_repository_id" {
  description = "Immutable numeric ID of the company infrastructure GitHub repository."
  type        = string
  default     = "1348443500"
}

variable "github_branch" {
  description = "Branch allowed to assume the Terraform execution role."
  type        = string
  default     = "main"
}
