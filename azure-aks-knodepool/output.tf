
output "nodepool_names" {
  description = "The names of the created node pools"
  value       = { for k, v in azurerm_kubernetes_cluster_node_pool.additional_pools : k => v.name }
}

output "nodepool_ids" {
  description = "The IDs of the created node pools"
  value       = { for k, v in azurerm_kubernetes_cluster_node_pool.additional_pools : k => v.id }
}

output "nodepool_profiles" {
  description = "The profiles used for each node pool"
  value       = { for k, v in local.nodepool_instances : k => v.profile }
}

output "nodepool_configs" {
  description = "The configurations applied to each node pool"
  value = { for k, v in azurerm_kubernetes_cluster_node_pool.additional_pools : k => {
    vm_size         = v.vm_size
    node_count      = v.node_count
    min_count       = v.min_count
    max_count       = v.max_count
    os_disk_size_gb = v.os_disk_size_gb
    os_type         = v.os_type
    max_pods        = v.max_pods
    node_labels     = v.node_labels
    node_taints     = v.node_taints
    vnet_subnet_id  = v.vnet_subnet_id
    zones           = v.zones
  } }
}