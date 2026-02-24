
output "workload_identity_provider_name" {
  description = "The full name of the Workload Identity Provider"
  value       = google_iam_workload_identity_pool_provider.github_actions_provider.name
}

output "workload_identity_provider_id" {
  description = "The ID of the Workload Identity Provider"
  value       = google_iam_workload_identity_pool_provider.github_actions_provider.workload_identity_pool_provider_id
}

output "workload_identity_pool_name" {
  description = "The full name of the Workload Identity Pool"
  value       = google_iam_workload_identity_pool.github_actions_pool.name
}

output "workload_identity_pool_id" {
  description = "The ID of the Workload Identity Pool"
  value       = google_iam_workload_identity_pool.github_actions_pool.workload_identity_pool_id
}

output "service_account_email" {
  description = "The email of the service account"
  value       = local.service_account_email
}

output "service_account_id" {
  description = "The ID of the service account"
  value       = var.service_account_id
}

output "github_action_config" {
  description = "Configuration to use in GitHub Actions workflow"
  value = {
    workload_identity_provider = google_iam_workload_identity_pool_provider.github_actions_provider.name
    service_account            = local.service_account_email
  }
}
