# AKS Nodepools Module Examples

## Simple Case

In the following example, one nodepool is configured: `general-purpose`, chosen from [THE MENU](./menu.md).

```hcl
module "aks_nodepools" {
  source         = "git::https://github.com/your-org/this-repo.git?ref=v1.2.0"
  cluster_id     = var.kubernetes_cluster
  agent_profiles = ["general-purpose"]
}
```

## Typical Case with Overrides

Building on the previous example, assuming there isn't another item on the THE MENU, you can specify your own node profile:

```hcl
 module "aks_nodepools" {
   source         = "git::https://github.com/your-org/this-repo.git?ref=v1.2.0"
   cluster_id     = var.kubernetes_cluster
   agent_profiles = ["general-purpose", "compute-intensive"]
 }
```

In the above example, two separate nodepools are configured: 'general-purpose', as seem in the previous example, and a customized nodepool profile, which the user has arbitrarily named `compute-intensive` and provided a tfvars file, appropriately named `compute-intensive.auto.tfvars`:

```hcl
# compute-intensive.auto.tfvars
 {
   vm_size": "Standard_F16s_v2",
   node_count": 3,
   enable_auto_scaling": true,
   min_count": 3,
   max_count": 10
 }
```

## Complex Case

Building on both of the previous examples:

```hcl
 module "aks_nodepools" {
    source         = "git::https://github.com/your-org/this-repo.git?ref=v1.2.0"
    cluster_id     = var.kubernetes_cluster
    agent_profiles = ["general-purpose", "gpu-intensive", "custom-pool", "memory-optimized"]
    vnet_subnet_id = azurerm_subnet.aks.id
 }
```
Here the user has elected to bring more custom configurations. 

This can be avoided by adding any of these custom configurations to the MENU directly, either through a PR or directly if you are forking this into your own module registry.

```hcl
# In gpu-intensive.auto.tfvars:
 {
    "vm_size": "Standard_NC24s_v3",
    "node_count": 2,
    "enable_auto_scaling": true,
    "min_count": 2,
    "max_count": 8,
    "node_labels": {
    "accelerator": "nvidia-tesla-v100"
  },
    "node_taints": ["gpu=true:NoSchedule"]
 }

# In custom-pool.auto.tfvars:
 {
    "vm_size": "Standard_E64-16s_v3",
    "node_count": 1,
    "enable_auto_scaling": false,
    "os_disk_size_gb": 512,
    "max_pods": 250,
    "node_labels": {
       "workload": "specialized"
    },
    "linux_os_config": {
       "sysctl_config": {
       "vm_max_map_count": 262144,
       "fs_file_max": 2097152
     },
       "transparent_huge_page_enabled": "always",
       "swap_file_size_mb": 1024
    }
 }
```

This latter method is cumbersome and blundersome --consider integrating your custom profiles into the MENU.
