



locals {
  vms = {
    small  = "Standard_D2s_v3"
    medium = "Standard_D2ads_v5"
    large  = "Standard_D8s_v3"
  }

  cluster_profiles = {
    basic = {
      default_node_pool = {
        node_count           = 2
        vm_size              = local.vms.medium
        os_sku               = "AzureLinux"
        auto_scaling_enabled = true
        min_count            = 2
        max_count            = 5
      }
      network_profile = {
        network_plugin = "azure"
        network_policy = "azure"
      }
      sku_tier     = "Free"
      support_plan = "KubernetesOfficial"
    }
    standard = {
      default_node_pool = {
        name                 = "system"
        node_count           = 2
        vm_size              = local.vms.medium
        os_sku               = "AzureLinux"
        auto_scaling_enabled = true
        min_count            = 2
        max_count            = 5
      }
      sku_tier     = "Free"
      support_plan = "KubernetesOfficial"
    }
    premium = {
      default_node_pool = {
        name                 = "system"
        vm_size              = local.vms.medium
        os_sku               = "AzureLinux"
        auto_scaling_enabled = true
        min_count            = 2
        max_count            = 5
        node_count           = 3
      }
    }
    advanced = {
      default_node_pool = {
        name                 = "system"
        node_count           = 3
        vm_size              = local.vms.large
        auto_scaling_enabled = true
        min_count            = 3
        max_count            = 5
        availability_zones   = [1, 2, 3]
      }
      network_profile = {
        network_plugin    = "azure"
        network_policy    = "azure"
        load_balancer_sku = "standard"
      }
      sku_tier     = "Standard"
      support_plan = "KubernetesOfficial"
    }
  }
}