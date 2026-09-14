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