terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.3"
    }
    deepmerge = {
      source  = "registry.terraform.io/isometry/deepmerge"
      version = ">= 0.2.3"
    }
  }
}

# NB: github auth
# ensure that the GITHUB_TOKEN and TF_VAR_github_token=${GITHUB_TOKEN} and ${GITHUB_OWNER}
# gh cli: login with `gh auth` and use `gh auth token` to find a token


