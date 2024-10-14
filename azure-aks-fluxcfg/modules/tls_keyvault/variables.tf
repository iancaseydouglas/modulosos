
variable "tls_keyvault_config" {
  type = object({
    location              = string
    resource_group_name   = string
    tenant_id             = string
    object_id             = string
    key_vault_name_prefix = optional(string, "fluxkv")
    key_name              = optional(string, "flux-ssh-private-key")
  })
  description = "Configuration for the TLS and Key Vault module"
  default     = null
}