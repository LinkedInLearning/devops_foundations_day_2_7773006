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

variable "environment_name" {
  description = "The name of the environment we're deploying into"
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

variable "allow_asg_egress" {
  description = "The EC2 instances in the ASG will be allowed to make outbound network calls to the IPs and security groups specified via this variable."
  type = map(object({
    ip_protocol                  = string
    from_port                    = number
    to_port                      = number
    referenced_security_group_id = optional(string)
    cidr_ipv4                    = optional(string)
  }))
  default = {}
}