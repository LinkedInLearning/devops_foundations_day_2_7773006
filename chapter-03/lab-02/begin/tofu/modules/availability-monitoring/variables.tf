# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name to use for all resources created by this module"
  type        = string
}

variable "app_url" {
  description = "The URL to test using Route 53 health checks."
  type = object({
    scheme = string
    ip     = optional(string)
    host   = optional(string)
    port   = number
    path   = string
  })
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "alerts_email_addresses" {
  description = "The email addresses to notify when an alert goes off"
  type        = set(string)
  default     = []
}