# bootstrap


# ==========================================
# Construct KinD cluster
# ==========================================

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository_deploy_key.this]

  embedded_manifests = true
  path               = "clusters/${var.cluster_name}"
}