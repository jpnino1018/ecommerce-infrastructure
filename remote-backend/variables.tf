variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Terraform state will be stored."
  type        = string
  default     = "rg-terraform-state"
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "East US"
}

variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
  default     = "ecommerceinfrastrgacc"
}

variable "container_name" {
  description = "The name of the storage container."
  type        = string
  default     = "tfstate"
}
