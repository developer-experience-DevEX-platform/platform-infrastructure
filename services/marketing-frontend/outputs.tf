output "site_bucket_name" {
  description = "Content bucket the release role may publish into."
  value       = module.static_site_release.site_bucket_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID."
  value       = module.static_site_release.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name."
  value       = module.static_site_release.cloudfront_domain_name
}

output "release_role_arn" {
  description = "ARN of the website GitHub Actions release role."
  value       = module.static_site_release.release_role_arn
}
