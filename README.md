# Platform infrastructure

Live Terraform stacks for this organization.

Reusable modules live in
[`terraform-modules`](https://github.com/developer-experience-DevEX-platform/terraform-modules)
and are pinned by git tag. This repository applies **service** stacks
(ECR, release IAM, GitHub variables). It does not apply AWS
networking, EKS, or Argo CD. The practice cluster is Linode.

## Start here

1. [Getting started](docs/getting-started.md) — add a service stack
2. [Overview](docs/overview.md) — bootstrap, services, cluster
3. [Container service](docs/services.md)

## Stacks

| Kind | Path | Status | Docs |
| --- | --- | --- | --- |
| Bootstrap | `bootstrap/aws-account` | Available, manual | [docs/bootstrap.md](docs/bootstrap.md) |
| Container service | `services/<name>` | Available | [docs/services.md](docs/services.md) |
| Lambda service | `services/<name>` | Exists | [docs/services.md](docs/services.md) |
| AWS environment (VPC/EKS/Argo CD) | `environments/` | Not applied | [docs/environments.md](docs/environments.md) |

How they fit together: [docs/overview.md](docs/overview.md).

## Platform

Pinning, GitHub OIDC, Terraform CI, and who applies live in
[docs/platform.md](docs/platform.md). Application developers do not
need that page, or this repository. Backstage will generate service
stacks later.
