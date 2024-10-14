
# Create GitHub repository if it doesn't exist
resource "github_repository" "repo" {
  name        = local.repo_name
  description = "Kubernetes cluster configuration repository"
  visibility  = "private"
  auto_init   = true

  lifecycle {
    ignore_changes = [description, visibility]
  }
}

# Add deploy key to GitHub repository
resource "github_repository_deploy_key" "deploy_key" {
  title      = "K8s Cluster Deploy Key"
  repository = github_repository.repo.name
  key        = tls_private_key.deploy.public_key_openssh
  read_only  = false

  depends_on = [github_repository.repo]
}

# Add signing key to GitHub repository
resource "github_user_gpg_key" "signing_key" {
  armored_public_key = tls_private_key.signing.public_key_pem
}
