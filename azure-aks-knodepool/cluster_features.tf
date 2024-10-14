locals {
  feature_sets = {

    autoscale_aggressive = {
      auto_scaler_profile = {
        balance_similar_node_groups      = true
        expander                         = "random"
        max_graceful_termination_sec     = 300
        max_node_provisioning_time       = "15m"
        max_unready_nodes                = 3
        max_unready_percentage           = 45
        new_pod_scale_up_delay           = "10s"
        scale_down_delay_after_add       = "5m"
        scale_down_delay_after_delete    = "30s"
        scale_down_delay_after_failure   = "3m"
        scan_interval                    = "10s"
        scale_down_unneeded              = "5m"
        scale_down_unready               = "5m"
        scale_down_utilization_threshold = 0.7
      }
    }

    autoscale_moderate = {
      auto_scaler_profile = {
        balance_similar_node_groups      = false
        expander                         = "random"
        max_graceful_termination_sec     = 600
        max_node_provisioning_time       = "15m"
        max_unready_nodes                = 3
        max_unready_percentage           = 45
        new_pod_scale_up_delay           = "0s"
        scale_down_delay_after_add       = "10m"
        scale_down_delay_after_delete    = "10s"
        scale_down_delay_after_failure   = "3m"
        scan_interval                    = "10s"
        scale_down_unneeded              = "10m"
        scale_down_unready               = "20m"
        scale_down_utilization_threshold = 0.5
      }
    }

    autoscale_conservative = {
      auto_scaler_profile = {
        balance_similar_node_groups      = true
        expander                         = "random"
        max_graceful_termination_sec     = 900
        max_node_provisioning_time       = "15m"
        max_unready_nodes                = 3
        max_unready_percentage           = 45
        new_pod_scale_up_delay           = "10s"
        scale_down_delay_after_add       = "15m"
        scale_down_delay_after_delete    = "5m"
        scale_down_delay_after_failure   = "3m"
        scan_interval                    = "10s"
        scale_down_unneeded              = "15m"
        scale_down_unready               = "15m"
        scale_down_utilization_threshold = 0.3
      }
    }

    azure_rbac = {
      enabled = true
      azure_active_directory_role_based_access_control = {
        managed                = true
        azure_rbac_enabled     = true
        admin_group_object_ids = []
        tenant_id              = null
      }
      local_account_disabled = false
    }

    weekend_maintenance = {
      maintenance_window = {
        allowed = [
          {
            day   = "Saturday"
            hours = [22, 23]
          },
          {
            day   = "Sunday"
            hours = [0, 1, 2, 3, 4, 5]
          }
        ]
      }
    }

    weeknight_maintenance = {
      maintenance_window = {
        allowed = [
          {
            day   = "Tuesday"
            hours = [1, 2, 3, 4]
          },
          {
            day   = "Wednesday"
            hours = [1, 2, 3, 4]
          },
          {
            day   = "Thursday"
            hours = [1, 2, 3, 4]
          }
        ]
      }
    }

    azure_cni_standard_net = {
      network_profile = {
        network_plugin = "azure"
        network_policy = "azure"
      }
    }

    azure_cni_overlay_net = {
      network_profile = {
        network_plugin      = "azure"
        network_plugin_mode = "overlay"
        pod_cidr            = "172.16.0.0/16"
      }
    }

    azure_cni_dynamic_net = {
      network_profile = {
        network_plugin = "azure"
        network_mode   = "transparent"
      }
    }

    azure_cni_static_cidr_net = {
      network_profile = {
        network_plugin = "azure"
        pod_cidr       = "10.244.0.0/16"
      }
    }

    enhanced_security = {
      azure_policy_enabled = true
      microsoft_defender = {
        enabled = true
      }
    }

    analytic_monitoring = {
      oms_agent = {
        enabled = true
      }
      monitor_metrics = {
        enabled             = true
        annotations_allowed = null
        labels_allowed      = null
      }
    }

    agentless_monitoring = {
      monitor_metrics = {
        enabled             = true
        annotations_allowed = "*"
        labels_allowed      = "*"
      }
    }

    private_cluster = {
      private_cluster_enabled             = true
      private_dns_zone_id                 = "System"
      private_cluster_public_fqdn_enabled = false
    }

    key_vault_secrets = {
      key_vault_secrets_provider = {
        enabled                  = true
        secret_rotation_enabled  = true
        secret_rotation_interval = "2m"
      }
    }

    oidc_workload_id = {
      oidc_issuer_enabled       = true
      workload_identity_enabled = true
    }

  }
}