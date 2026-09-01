variable "aws_region" {
  description = "AWS region supplied by the platform Terraform workflow."
  type        = string
}

variable "terraform_state_bucket" {
  description = "S3 bucket containing isolated platform Terraform state files."
  type        = string

  validation {
    condition     = length(trimspace(var.terraform_state_bucket)) > 0
    error_message = "terraform_state_bucket must not be empty."
  }
}
