output "cluster_name" {
  description = "Name of the staging EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_arn" {
  description = "ARN of the staging EKS cluster."
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "Endpoint of the staging EKS Kubernetes API."
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "Kubernetes version of the staging EKS cluster."
  value       = module.eks.cluster_version
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the staging EKS cluster."
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_security_group_id" {
  description = "ID of the EKS-managed cluster security group."
  value       = module.eks.cluster_security_group_id
}

output "cluster_role_arn" {
  description = "ARN of the staging EKS cluster IAM role."
  value       = module.eks.cluster_role_arn
}

output "node_role_arn" {
  description = "ARN of the staging EKS node IAM role."
  value       = module.eks.node_role_arn
}

output "node_group_name" {
  description = "Name of the staging EKS managed node group."
  value       = module.eks.node_group_name
}

output "node_group_arn" {
  description = "ARN of the staging EKS managed node group."
  value       = module.eks.node_group_arn
}

output "private_subnet_ids" {
  description = "Private subnet IDs used by staging EKS."
  value       = module.eks.private_subnet_ids
}

output "platform_admin_role_arn" {
  description = "ARN of the staging EKS platform administrator IAM role."
  value       = aws_iam_role.platform_admin.arn
}
