
locals {

  nodepool_instances = {
    for idx, profile in var.agent_profiles :
    idx => {
      profile = profile
      config  = try(jsondecode(file("${profile}.auto.tfvars")), {})
    }
  }

  nodepool_configs = {
    for idx, instance in local.nodepool_instances : idx => {
      name = substr("${instance.profile}${idx}", 0, 5)

      vm_size = try(coalesce(
        try(instance.config.vm_size, null),
        try(local.nodepool_catalog[instance.profile].vm_size, null),
        var.default_vm_size), null
      )

      node_count = try(coalesce(
        try(instance.config.node_count, null),
        try(local.nodepool_catalog[instance.profile].node_count, null),
        var.default_node_count), null
      )

      # enable_auto_scaling = try(coalesce(
      #   try(instance.config.enable_auto_scaling, null),
      #   try(local.nodepool_catalog[instance.profile].enable_auto_scaling, null),
      #   var.default_enable_auto_scaling), true
      # )

      auto_scaling_enabled = try(coalesce(
        try(instance.config.auto_scaling_enabled, null),
        try(local.nodepool_catalog[instance.profile].auto_scaling_enabled, null),
        var.default_auto_scaling_enabled), true
      )

      min_count = try(coalesce(
        try(instance.config.min_count, null),
        try(local.nodepool_catalog[instance.profile].min_count, null),
        var.default_min_count), null
      )

      max_count = try(coalesce(
        try(instance.config.max_count, null),
        try(local.nodepool_catalog[instance.profile].max_count, null),
        var.default_max_count), null
      )

      os_disk_size_gb = try(coalesce(
        try(instance.config.os_disk_size_gb, null),
        try(local.nodepool_catalog[instance.profile].os_disk_size_gb, null),
        var.default_os_disk_size_gb), null
      )

      os_type = try(coalesce(
        try(instance.config.os_type, null),
        try(local.nodepool_catalog[instance.profile].os_type, null),
        var.default_os_type), null
      )

      os_sku = try(coalesce(
        try(instance.config.os_sku, null),
        try(local.nodepool_catalog[instance.profile].os_sku, null),
        var.default_os_sku), null
      )

      max_pods = try(coalesce(
        try(instance.config.max_pods, null),
        try(local.nodepool_catalog[instance.profile].max_pods, null),
        var.default_max_pods), null
      )

      node_labels = merge(
        var.default_node_labels,
        try(local.nodepool_catalog[instance.profile].node_labels, {}),
        try(instance.config.node_labels, {})
      )

      node_taints = concat(
        var.default_node_taints,
        try(local.nodepool_catalog[instance.profile].node_taints, []),
        try(instance.config.node_taints, [])
      )

      vnet_subnet_id = try(coalesce(
        try(instance.config.vnet_subnet_id, null),
        var.vnet_subnet_id), null
      )

      pod_subnet_id = try(coalesce(
        try(instance.config.pod_subnet_id, null),
        var.pod_subnet_id), null
      )

      zones = try(coalesce(
        try(instance.config.zones, null),
        var.zones), null
      )

      linux_os_config = try(instance.config.linux_os_config, null)

      tags = merge(
        var.default_tags,
        try(instance.config.tags, {}),
        {
          "nodepool_identifier" = "${instance.profile}${idx}"
          "nodepool_profile"    = instance.profile
        }
      )
    }
  }
}