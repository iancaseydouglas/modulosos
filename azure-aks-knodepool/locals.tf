
locals {
  nodepool_catalog = {
    "general-purpose" = {
      vm_size              = "Standard_D2ads_v5"
      node_count           = 3
      auto_scaling_enabled = true
      min_count            = 2
      max_count            = 5
      os_disk_size_gb      = 128
      max_pods             = 30
    }
    "compute-intensive" = {
      vm_size              = "Standard_F16s_v2"
      node_count           = 3
      auto_scaling_enabled = true
      min_count            = 1
      max_count            = 10
      os_disk_size_gb      = 128
      max_pods             = 110
    }
    "memory-intensive" = {
      vm_size              = "Standard_E16s_v3"
      node_count           = 3
      auto_scaling_enabled = true
      min_count            = 1
      max_count            = 5
      os_disk_size_gb      = 256
      max_pods             = 60
    }
    "gpu-accelerated" = {
      vm_size              = "Standard_NC12s_v3"
      node_count           = 1
      auto_scaling_enabled = true
      min_count            = 1
      max_count            = 5
      os_disk_size_gb      = 256
      max_pods             = 110
      node_labels          = { "accelerator" = "nvidia-tesla-v100" }
      node_taints          = ["gpu=true:NoSchedule"]
    }
    "storage-intensive" = {
      vm_size              = "Standard_L16s_v2"
      node_count           = 3
      auto_scaling_enabled = false
      os_disk_size_gb      = 512
      max_pods             = 60
    }
    "burst-performance" = {
      vm_size              = "Standard_B8ms"
      node_count           = 3
      auto_scaling_enabled = true
      min_count            = 1
      max_count            = 10
      os_disk_size_gb      = 128
      max_pods             = 60
    }
    "high-performance" = {
      vm_size              = "Standard_H16r"
      node_count           = 2
      auto_scaling_enabled = false
      os_disk_size_gb      = 512
      max_pods             = 60
    }
    "low-priority" = {
      vm_size              = "Standard_D2s_v3"
      node_count           = 3
      auto_scaling_enabled = true
      min_count            = 0
      max_count            = 10
      os_disk_size_gb      = 128
      max_pods             = 60
      priority             = "Spot"
      eviction_policy      = "Delete"
    }
    "ultra-high-memory" = {
      vm_size              = "Standard_M128s"
      node_count           = 1
      auto_scaling_enabled = false
      os_disk_size_gb      = 1024
      max_pods             = 250
    }
    "network-intensive" = {
      vm_size              = "Standard_D8s_v3"
      node_count           = 3
      auto_scaling_enabled = true
      min_count            = 1
      max_count            = 5
      os_disk_size_gb      = 128
      max_pods             = 60
      node_labels          = { "networkTier" = "high" }
    }
    "confidential-compute" = {
      vm_size              = "Standard_DC4s_v2"
      node_count           = 2
      auto_scaling_enabled = false
      os_disk_size_gb      = 256
      max_pods             = 60
      node_labels          = { "confidentialCompute" = "true" }
    }
    "boomi" = {
      vm_size              = "Standard_D8ads_v5"
      node_count           = 4
      auto_scaling_enabled = false
      # os_disk_size_gb     = 256
      max_pods = 30
      # node_labels         = { "confidentialCompute" = "true" }
    }
  }
}