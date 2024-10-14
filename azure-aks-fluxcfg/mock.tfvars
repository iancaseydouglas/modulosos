
# mock tfvars

flux_config = {
  cluster_id   = "my-aks-cluster"
  key_vault_id = ""
  cluster_name = ""
  namespace    = "flux-system"
  scope        = "cluster"
  git = {
    repo_url               = "https://github.com/myorg/my-flux-repo"
    reference_type         = "branch"
    reference_value        = "main"
    visibility             = "private"
    auto_init              = true
    token                  = "tokenplace"
    ssh_private_key_base64 = "tokenplace"
  }
  keys = {
    deploy = {
      type     = "RSA"
      rsa_bits = 4096
    }
    signing = {
      type     = "RSA"
      rsa_bits = 4096
    }
    repo_layout = "platform-team-monorepo"
  }
}
