# main.tf

variable "flux_config" {
  type = object({
    cluster_id   = string
    key_vault_id = optional(string)
    cluster_name = optional(string)
    namespace    = optional(string, "flux-system")
    scope        = optional(string, "cluster")
    environment  = optional(string, "dev")
    git = optional(object({
      repo_url               = string
      reference_type         = optional(string, "branch")
      reference_value        = optional(string, "main")
      visibility             = optional(string, "private")
      auto_init              = optional(bool, true)
      token                  = optional(string)
      ssh_private_key_base64 = optional(string, null)
    }))
    keys = optional(object({
      deploy = optional(object({
        name        = optional(string, "deploy_key")
        type        = optional(string, "RSA")
        rsa_bits    = optional(number, "4096")
        ecdsa_curve = optional(string, "P384")
      }))
      signing = optional(object({
        name        = optional(string, "signing_key")
        type        = optional(string, "RSA")
        rsa_bits    = optional(number, "4096")
        ecdsa_curve = optional(string, "P384")
      }))
    }))
    repo_layout = optional(string, "platform-team-monorepo")
  })
  description = "flux configuration spec"
}
