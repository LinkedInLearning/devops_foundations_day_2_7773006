# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "environment_name" {
  description = "The name of the environment we're creating"
  type        = string
}

variable "cidr_block" {
  description = "The IP address range, in CIDR notation, to use for this VPC."
  type        = string
}
