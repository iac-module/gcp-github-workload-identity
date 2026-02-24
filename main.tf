# Enable required APIs
resource "google_project_service" "iam_credentials_api" {
  project = var.project_id
  service = "iamcredentials.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "sts_api" {
  project = var.project_id
  service = "sts.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}

# Create Workload Identity Pool
resource "google_iam_workload_identity_pool" "github_actions_pool" {
  project                   = var.project_id
  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_display_name
  description               = var.pool_description
  disabled                  = false

  depends_on = [
    google_project_service.iam_credentials_api,
    google_project_service.sts_api,
  ]
}

# Create Workload Identity Provider
resource "google_iam_workload_identity_pool_provider" "github_actions_provider" {
  # checkov:skip=CKV_GCP_125: attribute_condition is always enforced — either via the caller-supplied var.attribute_condition or the default CEL expression built from var.github_repositories, which restricts access to specific repositories.
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  display_name                       = var.provider_display_name
  description                        = var.provider_description
  disabled                           = false

  # Configure the OIDC provider
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
    # Set allowed audiences - if not specified, use the Workload Identity Provider name
    # This matches what GitHub Actions sends by default
    allowed_audiences = length(var.allowed_audiences) > 0 ? var.allowed_audiences : [
      "//iam.googleapis.com/projects/${var.project_id}/locations/global/workloadIdentityPools/${var.pool_id}/providers/${var.provider_id}"
    ]
  }

  # Map GitHub token claims to Google Cloud attributes
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.ref"              = "assertion.ref"
    "attribute.sha"              = "assertion.sha"
    "attribute.workflow"         = "assertion.workflow"
    "attribute.job_workflow_ref" = "assertion.job_workflow_ref"
    "attribute.environment"      = "assertion.environment"
  }

  # Optional attribute condition for fine-grained access control
  attribute_condition = var.attribute_condition != null ? var.attribute_condition : local.default_attribute_condition
}

# Create Service Account (if requested)
resource "google_service_account" "github_actions_sa" {
  count = var.create_service_account ? 1 : 0

  project      = var.project_id
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
  description  = var.service_account_description
}

# Get existing service account (if not creating new one)
data "google_service_account" "existing_sa" {
  count = var.create_service_account ? 0 : 1

  project    = var.project_id
  account_id = var.service_account_id
}

# Local to determine service account email and name
locals {
  service_account_email = var.create_service_account ? google_service_account.github_actions_sa[0].email : data.google_service_account.existing_sa[0].email
  service_account_name  = var.create_service_account ? google_service_account.github_actions_sa[0].name : data.google_service_account.existing_sa[0].name

  # Build repository conditions
  repository_conditions = [
    for repo in var.github_repositories :
    "attribute.repository == '${repo}'"
  ]

  # Build branch conditions if specified
  branch_conditions = length(var.allowed_branches) > 0 ? [
    for branch in var.allowed_branches :
    "attribute.ref == 'refs/heads/${branch}'"
  ] : []

  # Combine repository and branch conditions
  default_attribute_condition = length(var.allowed_branches) > 0 ? "(${join(" || ", local.repository_conditions)}) && (${join(" || ", local.branch_conditions)})" : join(" || ", local.repository_conditions)
}

# Allow the Workload Identity Provider to impersonate the Service Account
resource "google_service_account_iam_member" "workload_identity_user" {
  for_each = toset(var.github_repositories)

  service_account_id = local.service_account_name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions_pool.name}/attribute.repository/${each.value}"
}

# Assign roles to the service account
resource "google_project_iam_member" "service_account_roles" {
  for_each = toset(var.service_account_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${local.service_account_email}"
}
