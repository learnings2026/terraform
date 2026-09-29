output "instance_id" {
  description = "EC2 instance ID, or null when create_instance = false."
  value       = one(aws_instance.this[*].id)
}

output "private_ip" {
  description = "Private IP, or null when not created."
  value       = one(aws_instance.this[*].private_ip)
}
