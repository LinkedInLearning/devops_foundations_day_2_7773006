# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name to use for all resources created by this module"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy into"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets into which the ALB should be deployed"
  type        = list(string)
}

variable "app_security_group_id" {
  description = "The ID of the security group with the EC2 instances for which the ALB does health checks"
  type        = string
}

variable "custom_domain_name" {
  description = "Create an alias record in the hosted zone of the specified apex domain that points the specified subdomain at the ALB and adds a redirect in the ALB from the apex domain to the subdomain. For example, if the apex domain is foo.com and the subdomain is www, this module will point www.foo.com at the ALB and configure foo.com to redirect to www.foo.com."
  type = object({
    apex_domain = string
    subdomain   = string
  })
}