# gcp-github-workload-identity
TF module for Github Workload Identity

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.14 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 7.21 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 7.21 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_iam_workload_identity_pool.github_actions_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool) | resource |
| [google_iam_workload_identity_pool_provider.github_actions_provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider) | resource |
| [google_project_iam_member.service_account_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.iam_credentials_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.sts_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.github_actions_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.workload_identity_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_service_account.existing_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_audiences"></a> [allowed\_audiences](#input\_allowed\_audiences) | List of allowed audiences for the OIDC token | `list(string)` | `[]` | no |
| <a name="input_allowed_branches"></a> [allowed\_branches](#input\_allowed\_branches) | List of allowed branch names (e.g., ['main', 'develop']). If empty, all branches are allowed. | `list(string)` | `[]` | no |
| <a name="input_attribute_condition"></a> [attribute\_condition](#input\_attribute\_condition) | Optional CEL expression to further restrict authentication | `string` | `null` | no |
| <a name="input_create_service_account"></a> [create\_service\_account](#input\_create\_service\_account) | Whether to create a new service account or use an existing one | `bool` | `true` | no |
| <a name="input_github_repositories"></a> [github\_repositories](#input\_github\_repositories) | List of GitHub repositories that can authenticate (format: owner/repo) | `list(string)` | n/a | yes |
| <a name="input_pool_description"></a> [pool\_description](#input\_pool\_description) | Workload Identity Pool description | `string` | `"Workload Identity Pool for GitHub Actions"` | no |
| <a name="input_pool_display_name"></a> [pool\_display\_name](#input\_pool\_display\_name) | Workload Identity Pool display name | `string` | `"GitHub Actions Pool"` | no |
| <a name="input_pool_id"></a> [pool\_id](#input\_pool\_id) | Workload Identity Pool ID | `string` | `"github-actions-pool"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_provider_description"></a> [provider\_description](#input\_provider\_description) | Workload Identity Provider description | `string` | `"Workload Identity Provider for GitHub Actions"` | no |
| <a name="input_provider_display_name"></a> [provider\_display\_name](#input\_provider\_display\_name) | Workload Identity Provider display name | `string` | `"GitHub Actions Provider"` | no |
| <a name="input_provider_id"></a> [provider\_id](#input\_provider\_id) | Workload Identity Provider ID | `string` | `"github-actions-provider"` | no |
| <a name="input_service_account_description"></a> [service\_account\_description](#input\_service\_account\_description) | Service Account description | `string` | `"Service Account for GitHub Actions authentication"` | no |
| <a name="input_service_account_display_name"></a> [service\_account\_display\_name](#input\_service\_account\_display\_name) | Service Account display name | `string` | `"GitHub Actions Service Account"` | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | Service Account ID to be impersonated | `string` | n/a | yes |
| <a name="input_service_account_roles"></a> [service\_account\_roles](#input\_service\_account\_roles) | List of roles to assign to the service account | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_action_config"></a> [github\_action\_config](#output\_github\_action\_config) | Configuration to use in GitHub Actions workflow |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | The email of the service account |
| <a name="output_service_account_id"></a> [service\_account\_id](#output\_service\_account\_id) | The ID of the service account |
| <a name="output_workload_identity_pool_id"></a> [workload\_identity\_pool\_id](#output\_workload\_identity\_pool\_id) | The ID of the Workload Identity Pool |
| <a name="output_workload_identity_pool_name"></a> [workload\_identity\_pool\_name](#output\_workload\_identity\_pool\_name) | The full name of the Workload Identity Pool |
| <a name="output_workload_identity_provider_id"></a> [workload\_identity\_provider\_id](#output\_workload\_identity\_provider\_id) | The ID of the Workload Identity Provider |
| <a name="output_workload_identity_provider_name"></a> [workload\_identity\_provider\_name](#output\_workload\_identity\_provider\_name) | The full name of the Workload Identity Provider |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
