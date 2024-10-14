
# locals {
#   demo = {
#     cluster_name = "sigmund_bluepepper"
#     resource_group_name = join("_", ["rg", local.cluster_name])
#     location = "westus"
#   }
# }

# resource "azurerm_resource_group" "demo" {
#   count    = local.demo_only
#   name     = local.demo.resource_group_name
#   location = local.demo.location
# }


# resource "azurerm_kubernetes_cluster" "demo" {
#   count               = local.demo_only
#   name                = local.demo.cluster_name
#   location            = azurerm_resource_group.demo.location
#   resource_group_name = azurerm_resource_group.demo.name
#   dns_prefix          = local.demo.cluster_name

#   default_node_pool {
#     name       = "default"
#     node_count = 1
#     vm_size    = "Standard_DS2_v2"
#   }

#   identity {
#     type = "SystemAssigned"
#   }
# }

# resource "azurerm_kubernetes_cluster_extension" "demo" {
#   name           = "flux-demo"
#   cluster_id     = azurerm_kubernetes_cluster.demo.id
#   extension_type = "microsoft.flux"
# }

# resource "azurerm_kubernetes_flux_configuration" "demo" {
#   name       = "flux-config-demo"
#   cluster_id = local.cluster_id
#   namespace  = "flux-system"

#   git_repository {
#     url             = github_repository.repo.html_url
#     reference_type  = "branch"
#     reference_value = "main"
#   }

#   dynamic "kustomizations" {
#     for_each = local.repo_hierarchies[local.config.repo_hierarchy]
#     content {
#       name      = kustomizations.value.name
#       path      = kustomizations.value.path
#       depends_on = kustomizations.value.depends_on
#     }
#   }

#   depends_on = [
#     azurerm_kubernetes_cluster_extension.flux,
#     github_repository.repo,
#     github_repository_deploy_key.deploy_key
#   ]
# }
