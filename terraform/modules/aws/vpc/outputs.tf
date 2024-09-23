output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the Public Subnets."
  value       = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "The IDs of the Private Subnets."
  value       = aws_subnet.private.*.id
}

output "public_nat_subnet_ids" {
  description = "The IDs of the Public Nat Subnets."
  value       = aws_subnet.public_nat.*.id
}

output "public_route_table_ids" {
  description = "The IDs of the Public Subnet Reoute Table."
  value       = aws_route_table.public.*.id
}

output "private_route_table_ids" {
  description = "The IDs of the Private Subnet Reoute Table."
  value       = aws_route_table.private.*.id
}
