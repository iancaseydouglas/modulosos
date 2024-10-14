# AKS Nodepools a'la carte

This module manages additional node pools for an Azure Kubernetes Service (AKS) cluster. It provides a flexible and maintainable way to create and manage multiple node pools with different configurations.

The key differentiator: this module supports use-cases of any degree of complexity, while maintaining the same simple UI.

***Jump right into the [examples](./docs/examples.md), peruse the [MENU](./docs/menu.md), or read more about the [design approach](./docs/aesthetic.md)***

## TLDR

This module creates and manages additional node pools for an Azure Kubernetes Service (AKS) cluster, using a radically simple UI that remains simple even in the most complex use-cases.

Key features:

- Simple interface for creating node pools using pre-defined profiles
- Flexible configuration with three layers: defaults, catalog, and user overrides
- Advanced configuration options for power users
- Automatic unique naming for node pools
- Comprehensive Linux OS configuration support

### Basic Usage

```hcl
module "aks_nodepools" {
  source         = "path/to/module"
  cluster_id     = azurerm_kubernetes_cluster.main.id
  agent_profiles = ["general-purpose", "compute-intensive"]
}
```

In the above example, the user has chosen 2 separate nodepools from the [MENU](./docs/menu.md), "general-purpose" and "compute-intensive".

### Advanced Usage

```hcl
module "aks_nodepools" {
  source         = "path/to/module"
  cluster_id     = azurerm_kubernetes_cluster.main.id
  agent_profiles = ["general-purpose", "any-custom-pool"]
}
```

In the above example, the user has elected to provide custom configurations in `any-custom-pool.auto.tfvars`.

For more [details](./docs/aesthetic.md), see the full README and [examples](./docs/examples.md)

## Design Choices

1. **Separation of Logic**: All complex logic is contained in `locals.tf`, keeping the main resource definitions clean and readable.

2. **Flexible Configuration**: The module supports three layers of configuration:
   - Default values (lowest priority)
   - Predefined profiles in `nodepool_catalog`
   - User-provided configurations (highest priority)

3. **Dynamic Node Pool Creation**: Node pools are created dynamically based on the `agent_profiles` input, allowing for easy addition or removal of node pools.

4. **Unique Naming**: Each node pool gets a unique, deterministic name using a combination of its profile and index.

5. **Full Linux OS Configuration Support**: The module supports all Linux OS configuration options, with sensible defaults.

## Usage

```hcl
module "aks_nodepools" {
  source = "git::https://github.com/your-org/this-repo.git?ref=v1.2.0"

  cluster_id     = var.azurerm_kubernetes_cluster_id
  agent_profiles = ["Jumbo-GPU-AS", "general-purpose", "custom-pool"]
  vnet_subnet_id = var.azurerm_subnet_id

}
```

## Adding Configuration Sets

To add additional configuration sets to the interface:

1. Update the `nodepool_catalog` in `locals.tf`:

```hcl
nodepool_catalog = {
  "Jumbo-GPU-AS" = { ... },
  "general-purpose" = { ... },
  "new-profile" = {
    vm_size             = "Standard_D8s_v3"
    node_count          = 3
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 5
    os_disk_size_gb     = 256
    max_pods            = 100
  }
}
```

2. Create a corresponding `.auto.tfvars` file (e.g., `new-profile.auto.tfvars`) if you want to provide default overrides.

3. Use the new profile in your module call:

```hcl
agent_profiles = ["Jumbo-GPU-AS", "new-profile"]
```

When adding new configuration sets, be cautious of:
- Ensuring all required fields are specified
- Maintaining consistency with existing profiles
- Avoiding name conflicts with existing profiles

## Examples

[See the examples](docs/examples.md)


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_profiles"></a> [agent\_profiles](#input\_agent\_profiles) | List of agent profile names to create node pools. These names correspond to pre-defined configurations in our nodepool catalog. This is the primary way to specify desired node pools, emphasizing simplicity and best practices. | `list(string)` | `null` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The ID of the AKS cluster where the node pools will be created. | `string` | n/a | yes |
| <a name="input_default_enable_auto_scaling"></a> [default\_enable\_auto\_scaling](#input\_default\_enable\_auto\_scaling) | Whether to enable auto-scaling by default for node pools if not specified in the nodepool catalog or overrides. | `bool` | `false` | no |
| <a name="input_default_max_count"></a> [default\_max\_count](#input\_default\_max\_count) | The default maximum number of nodes for auto-scaling if not specified in the nodepool catalog or overrides. | `number` | `null` | no |
| <a name="input_default_max_pods"></a> [default\_max\_pods](#input\_default\_max\_pods) | The default maximum number of pods that can run on each node if not specified in the nodepool catalog or overrides. | `number` | `30` | no |
| <a name="input_default_min_count"></a> [default\_min\_count](#input\_default\_min\_count) | The default minimum number of nodes for auto-scaling if not specified in the nodepool catalog or overrides. | `number` | `null` | no |
| <a name="input_default_node_count"></a> [default\_node\_count](#input\_default\_node\_count) | The default number of nodes for each node pool if not specified in the nodepool catalog or overrides. | `number` | `1` | no |
| <a name="input_default_node_labels"></a> [default\_node\_labels](#input\_default\_node\_labels) | The default labels to be applied to nodes if not specified in the nodepool catalog or overrides. | `map(string)` | `{}` | no |
| <a name="input_default_node_taints"></a> [default\_node\_taints](#input\_default\_node\_taints) | The default taints to be applied to nodes if not specified in the nodepool catalog or overrides. | `list(string)` | `[]` | no |
| <a name="input_default_os_disk_size_gb"></a> [default\_os\_disk\_size\_gb](#input\_default\_os\_disk\_size\_gb) | The default OS disk size in GB for each node if not specified in the nodepool catalog or overrides. | `number` | `128` | no |
| <a name="input_default_os_type"></a> [default\_os\_type](#input\_default\_os\_type) | The default OS type for the nodes if not specified in the nodepool catalog or overrides. | `string` | `"Linux"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | A mapping of tags to assign as default to the node pools. These will be merged with any tags specified in the nodepool catalog or overrides. | `map(string)` | `{}` | no |
| <a name="input_default_vm_size"></a> [default\_vm\_size](#input\_default\_vm\_size) | The default VM size to use for node pools if not specified in the nodepool catalog or overrides. | `string` | `"Standard_DS2_v2"` | no |
| <a name="input_nodepool_advanced_config"></a> [nodepool\_advanced\_config](#input\_nodepool\_advanced\_config) | Advanced configuration for node pools. This allows for fine-grained control over each nodepool's settings, overriding both the default values and the nodepool catalog. Use this for complex scenarios that require customization beyond the pre-defined profiles. | <pre>map(object({<br>    vm_size             = optional(string)<br>    node_count          = optional(number)<br>    enable_auto_scaling = optional(bool)<br>    min_count           = optional(number)<br>    max_count           = optional(number)<br>    os_disk_size_gb     = optional(number)<br>    os_type             = optional(string)<br>    max_pods            = optional(number)<br>    node_labels         = optional(map(string))<br>    node_taints         = optional(list(string))<br>    tags                = optional(map(string))<br>    linux_os_config = optional(object({<br>      sysctl_config                 = optional(map(string))<br>      transparent_huge_page_enabled = optional(string)<br>      transparent_huge_page_defrag  = optional(string)<br>      swap_file_size_mb             = optional(number)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_vnet_subnet_id"></a> [vnet\_subnet\_id](#input\_vnet\_subnet\_id) | The ID of the subnet where the node pools will be created. If not specified, the AKS cluster's default subnet will be used. | `string` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A list of Availability Zones where the Node Pools should be created. If not specified, zone-redundant node pools will be created if the region supports it. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nodepool_configs"></a> [nodepool\_configs](#output\_nodepool\_configs) | The configurations applied to each node pool |
| <a name="output_nodepool_ids"></a> [nodepool\_ids](#output\_nodepool\_ids) | The IDs of the created node pools |
| <a name="output_nodepool_names"></a> [nodepool\_names](#output\_nodepool\_names) | The names of the created node pools |
| <a name="output_nodepool_profiles"></a> [nodepool\_profiles](#output\_nodepool\_profiles) | The profiles used for each node pool |
<!-- END_TF_DOCS -->
