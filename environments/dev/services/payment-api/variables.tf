variable "resource_group_name" {
  description = "Name of the existing resource group for the payment-api CI identity."
  type        = string
}

variable "location" {
  description = "Azure region in which to create the payment-api CI identity."
  type        = string
}

variable "acr_id" {
  description = "Resource ID of the existing Azure Container Registry."
  type        = string
}
