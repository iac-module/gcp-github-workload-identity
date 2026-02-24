
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "pool_id" {
  description = "Workload Identity Pool ID"
  type        = string
  default     = "github-actions-pool"
}

variable "pool_display_name" {
  description = "Workload Identity Pool display name"
  type        = string
  default     = "GitHub Actions Pool"
}

variable "pool_description" {
  description = "Workload Identity Pool description"
  type        = string
  default     = "Workload Identity Pool for GitHub Actions"
}

variable "provider_id" {
  description = "Workload Identity Provider ID"
  type        = string
  default     = "github-actions-provider"
}

variable "provider_display_name" {
  description = "Workload Identity Provider display name"
  type        = string
  default     = "GitHub Actions Provider"
}

variable "provider_description" {
  description = "Workload Identity Provider description"
  type        = string
  default     = "Workload Identity Provider for GitHub Actions"
}

variable "github_repositories" {
  description = "List of GitHub repositories that can authenticate (format: owner/repo)"
  type        = list(string)
}

variable "service_account_id" {
  description = "Service Account ID to be impersonated"
  type        = string
}

variable "service_account_display_name" {
  description = "Service Account display name"
  type        = string
  default     = "GitHub Actions Service Account"
}

variable "service_account_description" {
  description = "Service Account description"
  type        = string
  default     = "Service Account for GitHub Actions authentication"
}

variable "create_service_account" {
  description = "Whether to create a new service account or use an existing one"
  type        = bool
  default     = true
}

variable "service_account_roles" {
  description = "List of roles to assign to the service account"
  type        = list(string)
  default     = []
}

variable "attribute_condition" {
  description = "Optional CEL expression to further restrict authentication"
  type        = string
  default     = null
}

variable "allowed_branches" {
  description = "List of allowed branch names (e.g., ['main', 'develop']). If empty, all branches are allowed."
  type        = list(string)
  default     = []
}

variable "allowed_audiences" {
  description = "List of allowed audiences for the OIDC token"
  type        = list(string)
  default     = []
}
