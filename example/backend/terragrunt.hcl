include {
  path = find_in_parent_folders("root.hcl")
}
terraform {
  source = "https://github.com/iac-module/gcp-github-workload-identity.git?ref=0000" #v0.0.1"
}

locals {
  common_tags  = read_terragrunt_config(find_in_parent_folders("tags.hcl"))
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region       = local.region_vars.locals.region
  name         = "${basename(dirname(get_terragrunt_dir()))}-${basename(get_terragrunt_dir())}"
  repo_name    = "backend"
}

inputs = {
  project_id        = local.project_vars.locals.project_id
  pool_id           = "${local.name}"
  pool_display_name = "GHA Pool ${local.name}"

  # Workload Identity Provider configuration
  provider_id           = "github-provider-${local.name}"
  provider_display_name = "GH Provider for ${local.name}"

  github_repositories = [
    "${local.project_vars.locals.gh_organization}/${local.repo_name}"
  ]
  allowed_branches  = ["main"]
  allowed_audiences = ["${local.project_vars.locals.gh_organization}/${local.repo_name}"]

  # Service Account configuration
  service_account_id           = "${local.name}-sa"
  service_account_display_name = "GitHub Actions ${local.name} SA"
  create_service_account       = true
}
