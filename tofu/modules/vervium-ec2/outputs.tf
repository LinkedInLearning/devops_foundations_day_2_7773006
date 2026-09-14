output "ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.vervium_cloud_ai.public_ip
}