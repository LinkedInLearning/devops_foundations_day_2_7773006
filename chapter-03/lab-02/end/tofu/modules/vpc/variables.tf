# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name for the VPC and all other resources"
  type        = string
}

variable "cidr_block" {
  description = "The IP address range, in CIDR notation, to use for this VPC."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "vpc_endpoint_services" {
  description = "AWS service short names for interface VPC endpoints to create in the private subnets, such as ssm or ecr.api."
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_services_multi_az" {
  description = "If set to true, create the interface VPC endpoints in each AZ for higher availability and performance. If set to false, create the interface VPC endpoints in a single AZ to save money."
  type        = bool
  default     = false
}
