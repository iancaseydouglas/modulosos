locals {
  prefix      = "tf"
  resource    = "aks"
  location    = var.aks_config.location
  project     = var.aks_config.project
  environment = var.aks_config.environment
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
  lower   = true
}

locals {
  random_slug = random_string.random.id
  rendered_template = templatestring(local.template_string, {
    prefix      = local.prefix
    resource    = local.resource
    environment = local.environment
    location    = local.location
  })

  template_string = "${local.prefix}-${local.resource}-${local.environment}-${local.project}-${var.aks_config.location}-${local.random_slug}"
}


output "rendered_template" {
  value     = local.rendered_template
  sensitive = false
}

locals {
  cluster_name = local.rendered_template
}