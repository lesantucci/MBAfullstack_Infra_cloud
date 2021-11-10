terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "2.25"
        }
    }
}

provider "azurerm" {
    features {

    }
}

resource "azurerm_resource_group" "rg-exercicio4-infra" {
    location = "eastus"
    name = "rg-exercicio4-infra"
}

resource "azurerm_container_registry" "acr-exercicio4-infra" {
  name                = "exercicio4infraacer"
  resource_group_name = azurerm_resource_group.rg-exercicio4-infra.name
  location            = azurerm_resource_group.rg-exercicio4-infra.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "aks-exercicio4-infra" {
  name                = "aks-exercicio4-infra"
  location            = azurerm_resource_group.rg-exercicio4-infra.location
  resource_group_name = azurerm_resource_group.rg-exercicio4-infra.name
  dns_prefix          = "aks-exercicio4-infra"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  # az ad sp create-for-rbac --skip-assignment
  service_principal {
    client_id = "d683f84e-55fc-4028-bdb3-dcd6c74c85de"
    client_secret = "V~S4TIOgtetC2PcM4D~E-5p4wU9NSMS0.T"
  }

  role_based_access_control {
    enabled = true
  }

  addon_profile {
    http_application_routing {
      enabled = true
    }
  }

  tags = {
    Environment = "Production"
  }
}

data "azuread_service_principal" "aks_principal" {
  application_id = "d683f84e-55fc-4028-bdb3-dcd6c74c85de"
}

resource "azurerm_role_assignment" "acrpull-exercicio4-infra" {
  scope = azurerm_container_registry.acr-exercicio4-infra.id
  role_definition_name = "AcrPull"
  principal_id = data.azuread_service_principal.aks_principal.id
  skip_service_principal_aad_check = true
}
