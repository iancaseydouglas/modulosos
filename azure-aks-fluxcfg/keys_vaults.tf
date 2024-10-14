

# Generate deploy key pair
resource "tls_private_key" "deploy" {
  algorithm   = local.config.keys.deploy.type
  rsa_bits    = local.config.keys.deploy.type == "RSA" ? local.config.keys.deploy.rsa_bits : null
  ecdsa_curve = local.config.keys.deploy.type == "ECDSA" ? local.config.keys.deploy.ecdsa_curve : null
}

# Generate signing key pair
resource "tls_private_key" "signing" {
  algorithm   = local.config.keys.signing.type
  rsa_bits    = local.config.keys.signing.type == "RSA" ? local.config.keys.signing.rsa_bits : null
  ecdsa_curve = local.config.keys.signing.type == "ECDSA" ? local.config.keys.signing.ecdsa_curve : null
}

# stash keys

# deploykey - private 
resource "azurerm_key_vault_secret" "deploy_private_key" {
  count        = local.key_vault_enabled
  name         = "flux-${local.environment}-deploy-key-pvt"
  value        = tls_private_key.deploy.private_key_pem
  key_vault_id = local.key_vault_id
  content_type = "text/plain"

  tags = {
    purpose = "git repo deploy key (private) so that the fluxcd operator can read/write in the gitops repo"
  }
}

# deploykey - public 
resource "azurerm_key_vault_secret" "deploy_public_key" {
  count        = local.key_vault_enabled
  name         = "flux-${local.environment}-deploy-key-pub"
  value        = tls_private_key.deploy.public_key_openssh
  key_vault_id = local.key_vault_id
  content_type = "text/plain"

  tags = {
    purpose = "git repo deploy key (public) so that the fluxcd operator can read/write in the gitops repo"
  }
}

# signingkey - private 
resource "azurerm_key_vault_secret" "signing_private_key" {
  count        = local.key_vault_enabled
  name         = "flux-${local.environment}-signing-key-pvt"
  value        = tls_private_key.signing.private_key_pem
  key_vault_id = local.key_vault_id
  content_type = "text/plain"

  tags = {
    purpose = "signing commits on behalf of the fluxcd operator"
  }
}

# signingkey - public 
resource "azurerm_key_vault_secret" "signing_public_key" {
  count        = local.key_vault_enabled
  name         = "flux-${local.environment}-signing-key-pub"
  value        = tls_private_key.signing.public_key_openssh
  key_vault_id = local.key_vault_id
  content_type = "text/plain"

  tags = {
    purpose = "signing commits on behalf of the fluxcd operator"
  }
}