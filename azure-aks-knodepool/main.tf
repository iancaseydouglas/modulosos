
resource "random_pet" "nodepool_names" {
  for_each = local.nodepool_configs

  length    = 1
  separator = ""
  keepers = {
    node_pool_profile         = local.nodepool_instances[each.key].profile
    node_pool_vm_size         = each.value["vm_size"]
    node_pool_os_disk_size    = each.value["os_disk_size_gb"]
    node_pool_os_type         = each.value["os_type"]
    node_pool_os_sku          = each.value["os_sku"]
    node_pool_max_pods        = each.value["max_pods"]
    node_pool_vnet_subnet_id  = each.value["vnet_subnet_id"]
    node_pool_pod_subnet_id   = each.value["pod_subnet_id"]
    node_pool_zones           = each.value["zones"]
    node_pool_linux_os_config = each.value["linux_os_config"]
    index                     = each.key
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "additional_pools" {
  for_each = local.nodepool_configs

  kubernetes_cluster_id = var.cluster_id
  name                  = length("boomi${random_pet.nodepool_names[each.key].id}") > 12 ? substr("boomi${random_pet.nodepool_names[each.key].id}", 0, 12) : "boomi${random_pet.nodepool_names[each.key].id}"
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  auto_scaling_enabled  = each.value.auto_scaling_enabled
  os_disk_size_gb       = each.value.os_disk_size_gb
  os_type               = each.value.os_type
  os_sku                = lookup(each.value, "os_sku", null)
  max_pods              = each.value.max_pods
  node_labels           = each.value.node_labels
  node_taints           = each.value.node_taints
  vnet_subnet_id        = each.value.vnet_subnet_id
  pod_subnet_id         = lookup(each.value, "pod_subnet_id", null)
  zones                 = each.value.zones
  tags                  = each.value.tags

  dynamic "linux_os_config" {
    for_each = each.value.linux_os_config != null ? [each.value.linux_os_config] : []
    content {
      dynamic "sysctl_config" {
        for_each = linux_os_config.value.sysctl_config != null ? [linux_os_config.value.sysctl_config] : []
        content {
          fs_file_max                       = try(sysctl_config.value.fs_file_max, null)
          fs_inotify_max_user_watches       = try(sysctl_config.value.fs_inotify_max_user_watches, null)
          net_core_somaxconn                = try(sysctl_config.value.net_core_somaxconn, null)
          net_ipv4_ip_local_port_range_min  = try(sysctl_config.value.net_ipv4_ip_local_port_range_min, null)
          net_ipv4_ip_local_port_range_max  = try(sysctl_config.value.net_ipv4_ip_local_port_range_max, null)
          net_ipv4_neigh_default_gc_thresh1 = try(sysctl_config.value.net_ipv4_neigh_default_gc_thresh1, null)
          net_ipv4_tcp_fin_timeout          = try(sysctl_config.value.net_ipv4_tcp_fin_timeout, null)
          net_ipv4_tcp_keepalive_time       = try(sysctl_config.value.net_ipv4_tcp_keepalive_time, null)
          net_ipv4_tcp_max_syn_backlog      = try(sysctl_config.value.net_ipv4_tcp_max_syn_backlog, null)
          vm_max_map_count                  = try(sysctl_config.value.vm_max_map_count, null)
        }
      }
      transparent_huge_page_enabled = try(linux_os_config.value.transparent_huge_page_enabled, null)
      transparent_huge_page_defrag  = try(linux_os_config.value.transparent_huge_page_defrag, null)
      swap_file_size_mb             = try(linux_os_config.value.swap_file_size_mb, null)
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}