data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "staging/platform/eks/terraform.tfstate"
    region = var.aws_region
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "10.4.0"
  namespace        = "argocd"
  create_namespace = true

  values = [file("${path.module}/values.yaml")]

  wait    = true
  timeout = 600
}
