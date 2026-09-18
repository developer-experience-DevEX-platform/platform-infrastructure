# Environments

Path: `environments/<env>/platform/<stack>`

Staging is available. Production environment stacks are not shipped
(`environments/production/platform/` is a placeholder).

Each directory is its own Terraform root, with its own state key:

```text
staging/platform/networking/terraform.tfstate
staging/platform/eks/terraform.tfstate
staging/platform/argocd/terraform.tfstate
```

## Staging

```text
networking  →  eks  →  argocd
```

| Stack | Module | Owns |
| --- | --- | --- |
| `networking` | `aws/networking` | VPC, subnets, NAT, LB discovery tags |
| `eks` | `aws/eks` | Cluster, system node group, add-ons. Reads networking state. |
| `argocd` | Helm `argo-cd` 10.4.0 | Argo CD in the cluster. Reads EKS state. |

EKS does not create the VPC. Argo CD does not create the cluster.
Service workloads are **not** in these stacks; GitOps deploys them
from `platform-gitops`.

## Callers

Pin the same tag as every other stack:

```hcl
module "networking" {
  source = "git::https://github.com/developer-experience-DevEX-platform/terraform-modules.git//aws/networking?ref=v0.3.0"

  name               = "devex-staging"
  vpc_cidr           = "10.10.0.0/16"
  availability_zones = ["eu-west-2a", "eu-west-2b"]
  # ...
  nat_gateway_mode   = "single"
}
```

```hcl
module "eks" {
  source = "git::https://github.com/developer-experience-DevEX-platform/terraform-modules.git//aws/eks?ref=v0.3.0"

  cluster_name       = "devex-staging"
  kubernetes_version = "1.36"
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnet_ids
  # ...
}
```

## Argo CD

This stack is special in Terraform CI: PRs lint and template the Helm
chart instead of a full plan against the cluster. Apply on `main`
assumes the staging EKS admin role, imports the release if needed, and
rejects a plan that would replace `helm_release.argocd`.

GitOps workflows still do not talk to the cluster. They write image
tags into `platform-gitops`. Argo CD syncs from there.

## Production

Do not add production VPC or EKS stacks until the staging contract is
the one you want to copy. Production promotion of **services** is a
GitHub environment + GitOps SHA, not a second copy of these stacks
today.

## Related

- [Networking module](https://github.com/developer-experience-DevEX-platform/terraform-modules/blob/main/docs/aws/networking.md)
- [EKS module](https://github.com/developer-experience-DevEX-platform/terraform-modules/blob/main/docs/aws/eks.md)
- [Kubernetes GitOps](https://github.com/developer-experience-DevEX-platform/ci-cd-templates/blob/main/docs/cd/kubernetes-gitops.md)
