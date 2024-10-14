
variable "cluster_id" {
  type        = string
  description = "The ID of the AKS cluster where the node pools will be created."
}

variable "agent_profiles" {
  type        = list(string)
  description = "List of agent profile names to create node pools. These names correspond to pre-defined configurations in our nodepool catalog. This is the primary way to specify desired node pools, emphasizing simplicity and best practices."
  default     = null
}

variable "vnet_subnet_id" {
  type        = string
  description = "The ID of the subnet where the node pools will be created. If not specified, the AKS cluster's default subnet will be used."
  default     = null
}

variable "pod_subnet_id" {
  type        = string
  description = "The ID of the Subnet where the pods in the Node Pool should exist. Changing this forces a new resource to be created. If not specified, the AKS cluster's default subnet will be used."
  default     = null
}

variable "zones" {
  type        = list(string)
  description = "A list of Availability Zones where the Node Pools should be created. If not specified, zone-redundant node pools will be created if the region supports it."
  default     = null
}

variable "default_vm_size" {
  type        = string
  description = "The default VM size to use for node pools if not specified in the nodepool catalog or overrides."
  default     = "Standard_DS2_v2"
}

variable "default_node_count" {
  type        = number
  description = "The default number of nodes for each node pool if not specified in the nodepool catalog or overrides."
  default     = 1
}


variable "default_auto_scaling_enabled" {
  type        = bool
  description = "Whether to enable auto-scaling by default for node pools if not specified in the nodepool catalog or overrides."
  default     = false
}

variable "default_min_count" {
  type        = number
  description = "The default minimum number of nodes for auto-scaling if not specified in the nodepool catalog or overrides."
  default     = null
}

variable "default_max_count" {
  type        = number
  description = "The default maximum number of nodes for auto-scaling if not specified in the nodepool catalog or overrides."
  default     = null
}

variable "default_os_disk_size_gb" {
  type        = number
  description = "The default OS disk size in GB for each node if not specified in the nodepool catalog or overrides."
  default     = 128
}

variable "default_os_type" {
  type        = string
  description = "The default OS type for the nodes if not specified in the nodepool catalog or overrides."
  default     = "Linux"
}

variable "default_os_sku" {
  type        = string
  description = "The default OS type for the nodes if not specified in the nodepool catalog or overrides."
  default     = "AzureLinux"
}

variable "default_max_pods" {
  type        = number
  description = "The default maximum number of pods that can run on each node if not specified in the nodepool catalog or overrides."
  default     = 30
}

variable "default_node_labels" {
  type        = map(string)
  description = "The default labels to be applied to nodes if not specified in the nodepool catalog or overrides."
  default     = {}
}

variable "default_node_taints" {
  type        = list(string)
  description = "The default taints to be applied to nodes if not specified in the nodepool catalog or overrides."
  default     = []
}

variable "default_tags" {
  type        = map(string)
  description = "A mapping of tags to assign as default to the node pools. These will be merged with any tags specified in the nodepool catalog or overrides."
  default     = {}
}

variable "nodepool_advanced_config" {
  type = map(object({
    vm_size              = optional(string)
    node_count           = optional(number)
    auto_scaling_enabled = optional(bool)
    min_count            = optional(number)
    max_count            = optional(number)
    os_disk_size_gb      = optional(number)
    os_type              = optional(string)
    max_pods             = optional(number)
    node_labels          = optional(map(string))
    node_taints          = optional(list(string))
    tags                 = optional(map(string))
    linux_os_config = optional(object({
      sysctl_config                 = optional(map(string))
      transparent_huge_page_enabled = optional(string)
      transparent_huge_page_defrag  = optional(string)
      swap_file_size_mb             = optional(number)
    }))
  }))
  description = "Advanced configuration for node pools. This allows for fine-grained control over each nodepool's settings, overriding both the default values and the nodepool catalog. Use this for complex scenarios that require customization beyond the pre-defined profiles."
  default     = {}
}