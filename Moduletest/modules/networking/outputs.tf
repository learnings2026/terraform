# Outputs are the module's PUBLIC API. Anything not output is invisible
# to the caller (encapsulation).
output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets, in the order of the input CIDR list."
  value       = [for k in sort(keys(aws_subnet.public)) : aws_subnet.public[k].id]
}

output "security_group_id" {
  description = "ID of the default (no-inbound) security group."
  value       = aws_security_group.default.id
}
