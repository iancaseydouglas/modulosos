

resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

locals {
  config         = var.tls_keyvault_config
  key_vault_name = join("", [local.config.key_vault_name_prefix, random_string.suffix.result])
}
# the vault
resource "azurerm_key_vault" "this" {
  name                = local.key_vault_name
  location            = local.config.location
  resource_group_name = local.config.resource_group_name
  tenant_id           = local.config.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = local.config.tenant_id
    object_id = local.config.object_id

    secret_permissions = [
      "Get", "Set", "Delete", "Purge", "Recover"
    ]
  }
}
# the secret
resource "azurerm_key_vault_secret" "ssh_private_key" {
  name         = local.config.key_name
  value        = tls_private_key.ssh.private_key_openssh
  key_vault_id = azurerm_key_vault.this.id
}

