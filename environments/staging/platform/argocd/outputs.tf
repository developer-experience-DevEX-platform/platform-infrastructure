output "release_name" {
  description = "Name of the Argo CD Helm release."
  value       = helm_release.argocd.name
}

output "release_namespace" {
  description = "Namespace containing the Argo CD Helm release."
  value       = helm_release.argocd.namespace
}

output "release_status" {
  description = "Status of the Argo CD Helm release."
  value       = helm_release.argocd.status
}

output "chart_version" {
  description = "Pinned Argo CD Helm chart version."
  value       = helm_release.argocd.version
}
