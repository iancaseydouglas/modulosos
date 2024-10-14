# Azure Kubernetes Flux Configuration Module

This Terraform module provides a streamlined way to set up Flux on an Azure Kubernetes Service (AKS) cluster.

## Hierarchy choices

This is a critical decision. Every choice entails trade-offs. More on this later.

### Project First

Substitute for Projects any composition of moving parts: Service, Stack, Projects, etc. These are the focus.

```
clusters/
├── _common/
│   ├── dev/
│   ├── stg/
│   └── prd/
├── project-a/
│   ├── dev/
│   ├── stg/
│   └── prd/
└── project-b/
    ├── dev/
    ├── stg/
    └── prd/
```

Clusters tucked away. More on this soon.

```shell
clusters/
├── _common/
│   ├── flux-system/
│   ├── dev/
│   ├── stg/
│   └── prd/
├── project-a/
│   ├── dev/
│   │   └── cluster-1/
│   ├── stg/
│   │   └── cluster-1/
│   └── prd/
│       └── cluster-1/
└── project-b/
    ├── dev/
    │   ├── cluster-1/
    │   └── cluster-2/
    ├── stg/
    │   └── cluster-1/
    └── prd/
        └── cluster-1/
```

### Environment First

Let's discuss.

```shell
clusters/
├── dev/
│   ├── project-a/
│   └── project-b/
├── stg/
│   ├── project-a/
│   └── project-b/
└── prd/
    ├── project-a/
    └── project-b/
```

### All-Together

Can be organized if the directories use the FQDN of the cluster and each DN is meaningful.

```shell
clusters/
├── web.stg.us.internal/
├── db.stg.us.internal/
├── web.prd.us.internal/
├── db.prd.us.internal/
├── web.eu.internal/
└── db.eu.internal/
```

### Overlay

group-based config is done via overlays with no inheritance

```shell
└── cluster_svc
   ├── _overlays
   │  ├── all
   │  ├── dev
   │  ├── prd
   │  └── stg
   ├── dev
   │  ├── dev-cluster-01
   │  └── dev.auto.tfvars
   ├── prd
   │  ├── prd-cluster-01
   │  └── prd.auto.tfvars
   └── stg
      ├── stg-cluster-01
      └── stg.auto.tfvars
```

## Features

- Configures Flux on AKS clusters
- Supports multiple predefined kustomization sets
- Flexible Git repository configuration

## Usage

### As a Standalone Module

To use this module as a standalone is mostly the same as when using it in multiple different environments or CICD scenarios. Supply a standard `tfvars` file named `<environment>.auto.tfvars` (or similar) and invoke it as:

```hcl
module "aks_flux_config" {
  source  = "module-registry-or-path/aks-flux-config/"
  version = "1.0.0"

  cluster_id        = var.cluster_id
  git_config        = var.git_config
  kustomization_set = var.kustomization_set
}
```

### Using Per-Environment variable files

However you implement your terraform modules, you will likely have multiple environments and deployment contexts. These are best handled by using per-environment variable files.

Building on the last example, your varfile `<environment>.auto.tfvars` might look like:

```hcl
cluster_id = <cluster_id>
git_config = {
  url             = "https://github.com/your-org/your-gitops-repo.git"
  reference_type  = "branch"
  reference_value = "main"
}
kustomization_set = "standard"
```

### As part of a Stack or Service Module

To use this module as part of a composition of modules, as in a service stack or within a so-called 'root repo', the recommended approach is to use a `tfvars` file for the ***entire stack***, which will contain inputs for all of the modules provided by the service. This will likely still be specific to a single environment, but depending on your automation implementation, you may either want to use an auto-refernced tfvars file `<environment>.auto.tfvars` (or similar) or one named without the 'auto' and called explicitly using the `terraform -var=<path-to-file>` flag. Either way, invoke it as:

```hcl
## Usage

Basic usage with k8s cluster and keyvault

```hcl
module "flux_config" {
  source = "path/to/flux-config-module"

  flux_config = {
    name       = "my-flux-config"
    cluster_id = azurerm_kubernetes_cluster.example.id
    git = {
      repo_url      = "https://github.com/myorg/my-flux-repo"
      terraform_mgt = true
      visibility    = "private"
      auto_init     = true
    }
    keys = {
      key_vault_id = azurerm_key_vault.example.id
      key_name     = "flux-ssh-key"
    }
  }
}
}
```

With as many or as few of the named inputs either called out in the module invocation or provided within the environment varfile. The varfile will also contain all the other inputs that your service stack module may require.

>Notice that related inputs like `cluster_id` are sourced from other modules within the stack

This approach allows you to maintain different configurations for various environments or clusters, making it easy to manage and automate Flux deployments across your infrastructure.

### Basic Setup

If multiple environments aren't a concern, you can still use a varfile to keep things tidy, but, you can also just provide inputs via the main module interface:


```hcl
module "aks_flux_config" {
  source  = "your-registry/aks-flux-config/azurerm"
  version = "1.0.0"

  cluster_id = azurerm_kubernetes_cluster.example.id
  git_config = {
    url             = "https://github.com/your-org/your-repo.git"
    reference_type  = "branch"
    reference_value = "main"
  }
  kustomization_set = "standard"
}
```

This example sets up a basic Flux configuration using the "standard" kustomization set.

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_id | The ID of your AKS cluster | `string` | n/a | yes |
| git_config | Configuration for the Git repository | `object` | n/a | yes |
| kustomization_set | Kustomization set to use | `string` | `"standard"` | no |

## Outputs

| Name | Description |
|------|-------------|
| flux_config_id | The ID of the created Flux configuration |
| flux_config_name | The name of the Flux configuration |

<!-- BEGIN_TF_DOCS -->
flux_config = ""
<!-- END_TF_DOCS -->