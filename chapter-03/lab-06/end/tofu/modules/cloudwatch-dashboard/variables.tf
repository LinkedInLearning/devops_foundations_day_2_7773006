# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name to use for all resources created by this module"
  type        = string
}

variable "alb_arn" {
  description = "The ARN of the ALB"
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the target group"
  type        = string
}

variable "asg_name" {
  description = "The name of the ASG"
  type        = string
}