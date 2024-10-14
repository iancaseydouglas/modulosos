# Adding Features to the AKS Nodepools Module

This guide is intended for developers who want to extend the functionality of the AKS Nodepools module.

Be sure to read the [design aesthetic](./aesthetic.md) before you make changes.

> *maintain the balance between flexibility and simplicity*
>
> *shift all complexity into locals, away from the UI*
>
> *give simple users simple options; give power users powerful, simple options*
>
> ***Be complex, but not complicated. Be simple, but not simplistic.***

## Updating the Nodepool Catalog and Menu

When adding new nodepool types or modifying existing ones, it's crucial to keep both the internal nodepool catalog and the customer-facing menu in sync. This ensures consistency between what's offered to users and what's implemented in the module.

1. Update `locals.tf`:
   Add or modify the nodepool configuration in the `nodepool_catalog` local variable.

   ```hcl
   locals {
     nodepool_catalog = {
       "new-profile" = {
         vm_size             = "Standard_D4s_v3"
         node_count          = 3
         enable_auto_scaling = true
         min_count           = 1
         max_count           = 5
         os_disk_size_gb     = 128
         max_pods            = 60
         # Add any new properties here
       }
       # ... existing profiles ...
     }
   }
   ```

2. Update `menu.md`:
   Add a corresponding entry to the menu table.

   ```markdown
   | Profile Name | Short Name | Description |
   |--------------|------------|-------------|
   | New Profile  | new-profile| Description of the new profile |
   ```

Ensure that the short name in `MENU.md` matches the key used in `nodepool_catalog`.

## Adding Dynamic Blocks

When adding new features that require dynamic blocks in the `azurerm_kubernetes_cluster_node_pool` resource, follow these steps:

1. Add the configuration to `locals.tf`:
   ```hcl
   locals {
     nodepool_configs = {
       for idx, instance in local.nodepool_instances : idx => {
         # ... existing configuration ...
         new_feature = try(instance.config.new_feature, null) != null ? [{
           # Define the structure of your new feature here
         }] : []
       }
     }
   }
   ```

2. Add the dynamic block to `main.tf`:
   ```hcl
   resource "azurerm_kubernetes_cluster_node_pool" "additional_pools" {
     # ... existing configuration ...

     dynamic "new_feature" {
       for_each = each.value.new_feature
       content {
         # Define the content of your new feature here
       }
     }
   }
   ```

3. Update `variables.tf` to include any new input variables required for the feature.

4. Update `README.md` and `examples.md` to document the new feature and provide usage examples.

## Using Collection Functions

When working with collections in this module, it's important to understand when to use different functions:

1. `merge`: Use this function when combining maps. It's particularly useful for tags and labels where you want to combine values from multiple sources, with later sources overriding earlier ones.

   ```hcl
   tags = merge(var.default_tags, local.nodepool_catalog[profile].tags, instance.config.tags)
   ```

2. `coalesce`: Use this function when you want to select the first non-null value from a list of options. It's ideal for setting a value with a clear order of precedence.

   ```hcl
   vm_size = coalesce(instance.config.vm_size, local.nodepool_catalog[profile].vm_size, var.default_vm_size)
   ```

3. `try`: Use this function to safely access potentially non-existent values. It's crucial for preventing errors when a particular configuration or catalog entry doesn't exist.

   ```hcl
   node_count = try(instance.config.node_count, local.nodepool_catalog[profile].node_count, var.default_node_count)
   ```

By combining these functions, you can create a flexible, fault-tolerant configuration system that prioritizes user-provided values while falling back to sensible defaults when needed.

## Testing New Features

After adding a new feature:

1. Create new examples in `examples.md` showcasing the feature.
2. Test the module with various combinations of inputs to ensure it behaves correctly.
3. Update any relevant documentation, including inline comments and the `README.md`.

