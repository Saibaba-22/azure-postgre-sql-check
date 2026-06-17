# version setting block 
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.56.0"
    }
  }
}

# provider block 
provider "azurerm" {
  features {}
    # configuration options
}



# backend block 
terraform {
  backend "azurerm" {
    access_key = "WBgQ3hdwkjWZC9y1NbknjWqVvJNpD92HPUT8eN+mCD84HleIRP3lb1aMtBqdPFwc/ExJmX4ygTyp+AStXOnKNg=="
    storage_account_name = "saistorage12343256"
    container_name = "cont1"
    key = "prod.terraform.tfstate"
  }
}