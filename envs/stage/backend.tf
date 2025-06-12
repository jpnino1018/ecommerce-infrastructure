terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "ecommerceinfrastrgacc"
    container_name       = "tfstate"
    key                  = "stage.terraform.tfstate"
  }
}