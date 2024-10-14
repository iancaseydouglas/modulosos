
output "key_vault_id" {
  value       = azurerm_key_vault.this.id
  description = "The ID of the Key Vault"
}

output "key_vault_name" {
  value       = azurerm_key_vault.this.name
  description = "The name of the Key Vault"
}

output "ssh_public_key" {
  value       = tls_private_key.ssh.public_key_openssh
  description = "The public key in OpenSSH format"
}