output "vpc_id" {
  description = "ID of the staging VPC."
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "IPv4 CIDR of the staging VPC."
  value       = module.networking.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs of the staging public subnets."
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the staging private subnets."
  value       = module.networking.private_subnet_ids
}

output "public_route_table_ids" {
  description = "IDs of the staging public route tables."
  value       = module.networking.public_route_table_ids
}

output "private_route_table_ids" {
  description = "IDs of the staging private route tables."
  value       = module.networking.private_route_table_ids
}

output "internet_gateway_id" {
  description = "ID of the staging Internet Gateway."
  value       = module.networking.internet_gateway_id
}

output "nat_gateway_ids" {
  description = "IDs of the staging NAT gateways."
  value       = module.networking.nat_gateway_ids
}

output "availability_zones" {
  description = "Availability zones used by staging networking."
  value       = module.networking.availability_zones
}
