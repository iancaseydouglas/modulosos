
resource "azurerm_kubernetes_cluster_extension" "this" {
  name           = local.nickname
  cluster_id     = local.cluster_id
  extension_type = "microsoft.flux"
}

resource "azurerm_kubernetes_flux_configuration" "this" {
  name       = "flux-${local.environment}-configuration"
  cluster_id = local.cluster_id
  namespace  = local.namespace
  scope      = local.scope

  git_repository {
    url                    = local.config.git.repo_url
    reference_type         = local.config.git.reference_type
    reference_value        = local.config.git.reference_value
    ssh_private_key_base64 = tls_private_key.deploy.private_key_pem
  }

  dynamic "kustomizations" {
    for_each = local.repo_layouts
    content {
      name       = kustomizations.value.name
      path       = kustomizations.value.path
      depends_on = kustomizations.value.depends_on
    }
  }
  depends_on = [
    azurerm_kubernetes_cluster_extension.this,
    github_repository.repo,
    github_repository_deploy_key.deploy_key
  ]
}
