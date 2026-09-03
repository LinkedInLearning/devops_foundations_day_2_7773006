output "vpc" {
  description = "All the data on the VPC"
  value       = aws_vpc.vpc
}

output "public_subnets" {
  description = "All the data on the public subnets"
  value       = aws_subnet.public
}

output "private_subnets" {
  description = "All the data on the private subnets"
  value       = aws_subnet.private
}

output "interface_vpc_endpoint_ids" {
  description = "Map of AWS service short name to the interface VPC endpoint ID for that service."
  value       = { for service, endpoint in aws_vpc_endpoint.interface : service => endpoint.id }
}

output "interface_sg_id" {
  description = "ID of the security group for the interface endpoints."
  value       = length(aws_security_group.interface_vpc_endpoints) > 0 ? aws_security_group.interface_vpc_endpoints[0].id : null
}
