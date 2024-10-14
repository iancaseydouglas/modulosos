# Flux Module Usage Examples

This document provides examples of how to use the Flux module in various scenarios. These examples demonstrate different configuration options and best practices for setting up Flux GitOps on Azure Kubernetes Service (AKS) clusters.

## Table of Contents

1. [Basic Usage](#basic-usage)
2. [Advanced Usage with Custom Kustomizations](#advanced-usage-with-custom-kustomizations)
3. [Cluster Bootstrap with SSH Key from Environment Variable](#cluster-bootstrap-with-ssh-key-from-environment-variable)
4. [Using Azure Key Vault for SSH Key Storage](#using-azure-key-vault-for-ssh-key-storage)

## Basic Usage

This example demonstrates how to use the module with minimal configuration.

```hcl
# terraform.tfvars
cluster_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ContainerService/managedClusters/myAKSCluster"
git_repo = {
  url             = "https://github.com/myorg/flux-gitops"
  reference_value = "main"
}
```

```hcl
# main.tf
module "flux" {
  source     = "path/to/flux/module"
  cluster_id = var.cluster_id
  git_repo   = var.git_repo
}
```

## Advanced Usage with Custom Kustomizations

This example shows how to use the module with advanced kustomizations and custom cluster configuration directory.

```hcl
# terraform.tfvars
cluster_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ContainerService/managedClusters/myAKSCluster"
cluster_conf_dir  = "clusters/production/cluster-01"
kustomization_set = "advanced"
git_repo = {
  url             = "https://github.com/myorg/flux-gitops"
  reference_value = "main"
}
```

```hcl
# main.tf
module "flux" {
  source            = "path/to/flux/module"
  cluster_id        = var.cluster_id
  cluster_conf_dir  = var.cluster_conf_dir
  kustomization_set = var.kustomization_set
  git_repo          = var.git_repo
}
```

## Cluster Bootstrap with SSH Key from Environment Variable

This example demonstrates how to bootstrap a cluster using Flux with an SSH key provided via an environment variable.

1. Set your SSH private key as an environment variable:

```bash
export TF_VAR_ssh_private_key=$(cat /path/to/your/private_key)
```

2. In your `terraform.tfvars`:

```hcl
cluster_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ContainerService/managedClusters/myAKSCluster"

git_repo = {
  url             = "git@github.com:myorg/flux-gitops.git"
  reference_value = "main"
}

kustomization_set = "advanced"
cluster_conf_dir  = "clusters/production/cluster-01"
```

3. In your `main.tf`:

```hcl
module "flux" {
  source            = "path/to/flux/module"
  cluster_id        = var.cluster_id
  git_repo          = var.git_repo
  kustomization_set = var.kustomization_set
  cluster_conf_dir  = var.cluster_conf_dir
  ssh_private_key   = var.ssh_private_key
}
```

Note: Ensure that the public key corresponding to the provided private key is added as a deploy key with write access to your GitHub repository.

## Using Azure Key Vault for SSH Key Storage

This example shows how to use Azure Key Vault to securely store and retrieve the SSH private key for Flux.

1. First, ensure you have an Azure Key Vault set up and the SSH private key stored as a secret.

2. In your `terraform.tfvars`:

```hcl
cluster_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ContainerService/managedClusters/myAKSCluster"
key_vault_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.KeyVault/vaults/myKeyVault"
ssh_key_secret_name = "flux-ssh-private-key"

git_repo = {
  url             = "git@github.com:myorg/flux-gitops.git"
  reference_value = "main"
}

kustomization_set = "advanced"
cluster_conf_dir  = "clusters/production/cluster-01"
```

3. In your `main.tf`:

```hcl
data "azurerm_key_vault_secret" "ssh_private_key" {
  name         = var.ssh_key_secret_name
  key_vault_id = var.key_vault_id
}

module "flux" {
  source            = "path/to/flux/module"
  cluster_id        = var.cluster_id
  git_repo          = var.git_repo
  kustomization_set = var.kustomization_set
  cluster_conf_dir  = var.cluster_conf_dir
  ssh_private_key   = data.azurerm_key_vault_secret.ssh_private_key.value
}
```

This setup allows you to securely store and retrieve the SSH private key from Azure Key Vault, providing an additional layer of security for your Flux GitOps configuration.

## Best Practices

1. Always use secure methods to handle sensitive data like SSH keys. Avoid storing them in plain text files or version control.
2. Use environment variables or secure secret management solutions like Azure Key Vault for storing sensitive data.
3. Customize kustomizations based on your specific needs and cluster configuration.
4. Ensure proper RBAC and access controls are in place for your AKS cluster and Flux resources.
5. Regularly update Flux and your GitOps configurations to benefit from the latest features and security improvements.

By following these examples and best practices, you can effectively set up and manage Flux GitOps on your AKS clusters using Terraform.