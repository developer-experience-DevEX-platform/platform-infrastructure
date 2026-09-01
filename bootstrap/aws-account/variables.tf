variable "terraform_state_bucket_name" {
  description = "Globally unique name for the Terraform remote-state S3 bucket."
  type        = string
}

variable "github_owner" {
  description = "GitHub organization that owns the company infrastructure repository."
  type        = string
}

variable "github_repository" {
  description = "Company infrastructure GitHub repository allowed to assume the Terraform execution role."
  type        = string
}

variable "github_branch" {
  description = "Branch allowed to assume the Terraform execution role."
  type        = string
  default     = "main"
}
