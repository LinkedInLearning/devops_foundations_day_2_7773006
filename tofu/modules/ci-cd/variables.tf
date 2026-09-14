# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "github_owner" {
  description = "GitHub owner/org for the repository that can assume these roles."
  type        = string
}

variable "github_owner_id" {
  description = "The immutable ID of the GitHub owner/org for the repository that can assume these roles. You can get this from the GitHub API, or by opening the repo in your browser, doing View Source, and grabbing the 'content' value of the 'octolytics-dimension-user_id' meta tag. This is required for all repos created after July 15, 2026. Set to null only for repos created before that date."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name that can assume these roles."
  type        = string
}

variable "github_repo_id" {
  description = "The immutable ID of the GitHub respository that can assume these roles. You can get this from the GitHub API, or by opening the repo in your browser, doing View Source, and grabbing the 'content' value of the 'octolytics-dimension-repository_id' meta tag. This is required for all repos created after July 15, 2026. Set to null only for repos created before that date."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "plan_role_name" {
  description = "Name of the IAM role used for plan"
  type        = string
  default     = "github-actions-plan"
}

variable "apply_role_name" {
  description = "Name of the IAM role used for apply"
  type        = string
  default     = "github-actions-apply"
}

variable "github_oidc_provider_url" {
  description = "GitHub OIDC provider URL."
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "github_oidc_thumbprints" {
  description = "Thumbprints for the GitHub OIDC provider."
  type        = list(string)
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}
