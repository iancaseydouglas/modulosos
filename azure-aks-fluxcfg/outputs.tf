
output "git_repo_url" {
  value       = github_repository.repo.html_url
  description = "URL of the created Git repository"
}

# output "deploy_key_id" {
#   value       = github_repository_deploy_key.deploy_key.id
#   description = "ID of the deploy key added to the Git repository"
# }

# output "signing_key_id" {
#   value       = github_user_gpg_key.signing_key.id
#   description = "ID of the signing key added to the Git account"
# }

# output "deploy_private_key_secret_id" {
#   value       = local.config.key_vault_id != null ? azurerm_key_vault_secret.deploy_private_key[0].id : null
#   description = "Azure Key Vault Secret ID for the deploy private key"
#   sensitive   = true
# }

output "deploy_public_key_secret_id" {
  value       = local.config.key_vault_id != null ? azurerm_key_vault_secret.deploy_public_key[0].id : null
  description = "Azure Key Vault Secret ID for the deploy public key"
}

# output "signing_private_key_secret_id" {
#   value       = local.config.key_vault_id != null ? azurerm_key_vault_secret.signing_private_key[0].id : null
#   description = "Azure Key Vault Secret ID for the signing private key"
#   sensitive   = true
# }

output "signing_public_key_secret_id" {
  value       = local.config.key_vault_id != null ? azurerm_key_vault_secret.signing_public_key[0].id : null
  description = "Azure Key Vault Secret ID for the signing public key"
}


output "kubernetes_cluster_id" {
  value       = local.cluster_id
  description = "ID of the AKS cluster"
}

output "flux_configuration_id" {
  value       = azurerm_kubernetes_flux_configuration.this.id
  description = "ID of the Flux configuration"
}