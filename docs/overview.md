# Overview

This repository answers: which live stack owns this AWS or GitHub
object? It does not define the reusable module. That is
[`terraform-modules`](https://github.com/developer-experience-DevEX-platform/terraform-modules).

The practice Kubernetes cluster is **Linode**. Terraform in this repo
does not create a VPC, EKS cluster, or Argo CD on AWS.

```text
bootstrap/aws-account          state bucket, OIDC, plan/apply roles
services/<service>             ECR + release role (or Lambda)
Linode                         cluster (not Terraform in this repo)
```

```text
service repo                 Dockerfile, ci.yml, release.yml
ci-cd-templates              build, scan, publish, GitOps SHA
terraform-modules            reusable modules, pinned by tag
platform-infrastructure      this repo: apply service stacks
AWS                          ECR, IAM, OIDC, state
Linode                       the cluster
```

## Who calls what

| Stack | Calls | Terraform CI |
| --- | --- | --- |
| Bootstrap | `aws/s3` | No. Administrator apply. |
| Container service | `platform/service-container-release` | Yes. Plan on PR, apply on `main`. |
| Lambda service | `platform/service-lambda` | Yes. Same pipeline. |
| `environments/` (VPC/EKS/Argo CD) | `aws/networking`, `aws/eks`, Helm | **Never.** Cluster is Linode. |

Service stacks do not create a cluster. Backstage will generate
service stacks later; the module contract is already
[container release](https://github.com/developer-experience-DevEX-platform/terraform-modules/blob/main/docs/platform/service-container-release.md).

GitOps workflows still do not talk to the cluster. They write image
tags into `platform-gitops`. Argo CD on Linode can sync from there.

## Pinning

Every git module source ends with `?ref=<tag>`. All stacks share one
tag. Bump them together.

Relative `source = "../../modules/..."` is not allowed. Modules do not
live here.

## What belongs in a stack

The stack owns providers, the S3 backend, which module, and the IDs
CI discovers from GitHub.

The module owns resources and locked defaults.

The service repo owns application code.

Not supported:

- Applying AWS networking, EKS, or Argo CD from this pipeline
- In-tree modules
- Following `main` for Terraform modules
- Optional flags that weaken encryption, immutability, or scanning
- Long-lived AWS keys in GitHub
- Integration-test Secrets Manager roles

## Related

- [Bootstrap](bootstrap.md)
- [Services](services.md)
- [Environments](environments.md)
- [Platform](platform.md)
