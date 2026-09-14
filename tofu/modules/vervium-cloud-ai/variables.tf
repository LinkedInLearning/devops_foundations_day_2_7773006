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

variable "custom_domain_name" {
  description = "Create an alias record in the hosted zone of the specified apex domain that points the specified subdomain at the ALB and adds a redirect in the ALB from the apex domain to the subdomain. For example, if the apex domain is foo.com and the subdomain is www, this module will point www.foo.com at the ALB and configure foo.com to redirect to www.foo.com."
  type = object({
    apex_domain = string
    subdomain   = string
  })
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "custom_tags" {
  description = "Custom tags to apply to the EC2 instances"
  type        = map(string)
  default     = {}
}