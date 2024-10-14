
locals {
  base_dir = "."
  repo_hierarchy = {
    "platform-team-monorepo" = [
      {
        name       = "flux-system"
        path       = "${local.base_dir}/clusters/${local.config.cluster_name}/flux-system"
        depends_on = []
      },
      {
        name       = "infrastructure-core"
        path       = "${local.base_dir}/infrastructure/core"
        depends_on = ["flux-system"]
      },
      {
        name       = "infrastructure-services"
        path       = "${local.base_dir}/infrastructure/services"
        depends_on = ["infrastructure-core"]
      },
      {
        name       = "applications"
        path       = "${local.base_dir}/applications"
        depends_on = ["infrastructure-services"]
      }
    ],
    "app-team-monorepo" = [
      {
        name       = "flux-system"
        path       = "${local.base_dir}/clusters/${local.config.cluster_name}/flux-system"
        depends_on = []
      },
      {
        name       = "app"
        path       = "./deploy/manifests"
        depends_on = ["flux-system"]
      }
    ]
  }

  repo_layouts = local.repo_hierarchy[local.config.repo_hierarchy]
}


# locals {
#   repo_hierarchies = {
#     "infrastructure-apps" = [
#       {
#         name = "infrastructure"
#         path = "./infrastructure"
#       },
#       {
#         name = "apps"
#         path = "./apps"
#         depends_on = ["infrastructure"]
#       }
#     ]
#     "project-first" = [
#       {
#         name = "common"
#         path = "./clusters/_common"
#       },
#       {
#         name = "projects"
#         path = "./clusters"
#         depends_on = ["common"]
#       }
#     ]
#     "environment-first" = [
#       {
#         name = "environments"
#         path = "./clusters"
#       }
#     ]
#     "flat" = [
#       {
#         name = "clusters"
#         path = "./clusters"
#       }
#     ]
#     "overlay" = [
#       {
#         name = "overlays"
#         path = "./_overlays"
#       },
#       {
#         name = "environments"
#         path = "."
#         depends_on = ["overlays"]
#       }
#     ]
#   }
# }


