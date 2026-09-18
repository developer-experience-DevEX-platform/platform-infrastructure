# Platform infrastructure

Live Terraform stacks for this organization.

Reusable modules live in
[`terraform-modules`](https://github.com/developer-experience-DevEX-platform/terraform-modules)
and are pinned by git tag. This repository applies them. It does not
contain modules.

## Start here

1. [Getting started](docs/getting-started.md) — add a service stack
2. [Overview](docs/overview.md) — bootstrap, environments, services
3. Your stack: [container service](docs/services.md) or
   [staging environment](docs/environments.md)

## Stacks

| Kind | Path | Status | Docs |
| --- | --- | --- | --- |
| Bootstrap | `bootstrap/aws-account` | Available | [docs/bootstrap.md](docs/bootstrap.md) |
| Staging environment | `environments/staging/platform/*` | Available | [docs/environments.md](docs/environments.md) |
| Production environment | `environments/production/platform/*` | Not shipped | [docs/environments.md](docs/environments.md) |
| Container service | `services/<name>` | Available | [docs/services.md](docs/services.md) |
| Lambda service | `services/<name>` | Exists | [docs/services.md](docs/services.md) |

How they fit together: [docs/overview.md](docs/overview.md).

## Platform

Pinning, GitHub OIDC, Terraform CI, and who applies live in
[docs/platform.md](docs/platform.md). Application developers do not
need that page, or this repository.
