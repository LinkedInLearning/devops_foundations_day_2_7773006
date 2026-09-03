# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name to use for all resources created by this module"
  type        = string
}

variable "ami" {
  description = "The ID of the AMI to deploy"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to deploy"
  type        = string
}

variable "min_instances" {
  description = "Minimum number of instances to have in the ASG"
  type        = number
}

variable "max_instances" {
  description = "Maximum number of instances to have in the ASG"
  type        = number
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy into"
  type        = string
}

variable "asg_subnet_ids" {
  description = "The IDs of the subnets into which the instances should be deployed"
  type        = list(string)
}

variable "alb_subnet_ids" {
  description = "The IDs of the subnets into which the ALB should be deployed"
  type        = list(string)
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "key_name" {
  description = "The name of the EC2 Key Pair to associate with the EC2 instance"
  type        = string
  default     = null
}