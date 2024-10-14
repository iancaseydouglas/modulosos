
# data "azurerm_resource_group" "main" {
#   name = var.resource_group_name
# }

# locals {
#   group = {
#     name     = data.azurerm_resource_group.main.name
#     id       = data.azurerm_resource_group.main.id
#     tags     = data.azurerm_resource_group.main.tags
#     location = data.azurerm_resource_group.main.location
#   }
# }
#  

locals {
  environment       = var.flux_config.environment
  repo_url          = var.flux_config.git.repo_url
  repo_parts        = split("/", local.repo_url)
  repo              = local.repo_parts[length(local.repo_parts) - 1]
  repo_name         = replace(local.repo, ".git", "")
  key_vault_id      = var.flux_config.key_vault_id
  cfg               = var.flux_config
  cluster_id        = local.cfg.cluster_id
  cluster_name      = try(split("/", local.cluster_id)[8], local.cluster_id)
  moniker           = local.cluster_name
  cluster_path      = join("/", ["clusters", local.cluster_name])
  flux_name         = join("_", ["flux", local.cluster_name])
  namespace         = coalesce(local.cfg.namespace, "flux-system")
  scope             = local.cfg.scope
  nickname          = "fluxcfg"
  key_vault_enabled = local.key_vault_id != null ? 1 : 0
  deploy_key_title  = join("-", [local.nickname, "deploy-key"])
  demo_only         = local.cluster_id == null ? 1 : 0
}

# base config

locals {
  default_config = {
    key_vault_id = "old-betsy"
    namespace    = "flux-system"
    scope        = "cluster"
    git = {
      repo_url        = "default_string"
      reference_type  = "branch"
      reference_value = "main"
      visibility      = "private"
      auto_init       = true
      # ssh_private_key_base64 = optional(string, null)
    }
    keys = {
      deploy = {
        name        = "k8s-cluster-deploy"
        type        = "RSA"
        rsa_bits    = "4096"
        ecdsa_curve = "P384"
      }
      signing = {
        name        = "k8s-cluster-signing"
        type        = "RSA"
        rsa_bits    = "4096"
        ecdsa_curve = "P384"
      }
    }
    repo_hierarchy = "platform-team-monorepo"
  }
}

# layered configs

locals {
  config = provider::deepmerge::mergo(local.default_config, local.cfg)
}




