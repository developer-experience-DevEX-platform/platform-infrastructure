# Overview

This repository answers: which live stack owns this AWS or GitHub
object? It does not define the reusable module. That is
[`terraform-modules`](https://github.com/developer-experience-DevEX-platform/terraform-modules).

```text
bootstrap/aws-account          state bucket, OIDC, plan/apply roles
environments/<env>/platform    VPC, EKS, Argo CD
services/<service>             one service: ECR + release role, or Lambda
```

```text
service repo                 Dockerfile, ci.yml, release.yml
ci-cd-templates              build, scan, publish, GitOps SHA
terraform-modules            reusable modules, pinned by tag
platform-infrastructure      this repo: apply
AWS / GitHub                 the objects
```

## Who calls what

| Stack | Calls | Does not call |
| --- | --- | --- |
| Bootstrap | `aws/s3` | ECR, EKS, service IAM |
| Environment networking | `aws/networking` | EKS |
| Environment EKS | `aws/eks` | VPC |
| Environment Argo CD | Helm release | `terraform-modules` |
| Container service | `platform/service-container-release` | `aws/ecr` directly |
| Lambda service | `platform/service-lambda` | `aws/lambda` directly |

Service stacks do not create a VPC. Environment stacks do not create
service ECR repositories. GitOps workflows do not talk to the cluster;
Argo CD syncs from `platform-gitops`.

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

- In-tree modules
- Following `main` for Terraform modules
- Optional flags that weaken encryption, immutability, or scanning
- Long-lived AWS keys in GitHub
- Integration-test Secrets Manager roles

## Related

- [Bootstrap](bootstrap.md)
- [Environments](environments.md)
- [Services](services.md)
- [Platform](platform.md)
