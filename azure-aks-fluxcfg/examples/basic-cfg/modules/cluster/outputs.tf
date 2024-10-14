output "repo" {
  value = github_repository.this
}

output "deploykey" {
  value = github_repository_deploy_key.this
}

output "tls_private_key" {
  value     = tls_private_key.flux
  sensitive = true
}


output "kind_cluster" {
  value     = kind_cluster.this
  sensitive = true
}