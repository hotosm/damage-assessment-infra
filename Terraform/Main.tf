# Configure the Azure provider
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.74.0"
    }
  }
}

data "azuread_client_config" "current" {}
provider "azuread" {
  tenant_id = var.tenant_id
}


data "azurerm_client_config" "current" {}
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "app" {
  name     = "rg-${var.org_abb}-${var.reg_abb}-${var.env_abb}-app"
  location = var.region
}

resource "azurerm_resource_group" "loganalytics" {
  name     = "rg-${var.org_abb}-${var.reg_abb}-${var.env_abb}-loganalytics"
  location = var.region
}

resource "azurerm_resource_group" "network" {
  name     = "rg-${var.org_abb}-${var.reg_abb}-${var.env_abb}-network"
  location = var.region
}

resource "azurerm_resource_group" "secrets" {
  name     = "rg-${var.org_abb}-${var.reg_abb}-${var.env_abb}-secrets"
  location = var.region
}

resource "azurerm_resource_group" "sharedservices" {
  name     = "rg-${var.org_abb}-${var.reg_abb}-${var.env_abb}-sharedservices"
  location = var.region
}

resource "azurerm_resource_group" "storage" {
  name     = "rg-${var.org_abb}-${var.reg_abb}-${var.env_abb}-storage"
  location = var.region
}
