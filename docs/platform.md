# Platform

For people who maintain these stacks. Teams adding a service can skip
this page; use [getting started](getting-started.md).

## Pinning

Documented stacks pin
[`terraform-modules`](https://github.com/developer-experience-DevEX-platform/terraform-modules)
at a git tag. Do not pin `main`. A lab stack may pin a branch while a
module is under test; switch it back to a tag before the stack is
done.

CI/CD templates pin reusable workflows at `@main`. Terraform does not.

All **applied** stacks in this repository should share one tag. Today
that tag is `v0.3.0`. Bump every `?ref=` together after you cut a
module release.

A greenfield apply does not need `moved` blocks. Use them only when an
object already exists in state and its address changed.

## Terraform CI

Workflow: `.github/workflows/terraform.yml`

Triggers on changes under `services/` or the workflow file itself.
It plans and applies **service stacks only** (ECR, release IAM, GitHub
variables). Bootstrap is applied by an administrator. AWS networking,
EKS, and Argo CD are never in the matrix; see
[environments](environments.md).

| Event | Role | What runs |
| --- | --- | --- |
| Pull request | `devex-terraform-plan` | `fmt`, `init`, `validate`, `plan` per affected `services/<name>` |
| Push to `main` | `devex-terraform-platform` | same, then `apply` |

If only the workflow file changes, every directory under `services/`
is planned.

## Providers

Every service stack configures AWS and GitHub:

```hcl
provider "aws" {
  region = var.aws_region
}

provider "github" {
  owner = var.github_owner
}
```

`GITHUB_TOKEN` in CI is `PLATFORM_GITHUB_TOKEN`.

Terraform in CI is `1.13.5`.

## GitHub identities

Numeric owner and repository IDs are immutable. The plan/apply
workflow discovers them with `gh api`. Do not trust a renamed slug
alone in OIDC `sub`.

The account OIDC provider is bootstrap. Its ARN is
`vars.AWS_GITHUB_OIDC_PROVIDER_ARN`.

## Cluster

The practice cluster is Linode. This pipeline does not create it and
does not assume an EKS admin role.

## Related

- [terraform-modules platform notes](https://github.com/developer-experience-DevEX-platform/terraform-modules/blob/main/docs/platform.md)
- [CI/CD platform notes](https://github.com/developer-experience-DevEX-platform/ci-cd-templates/blob/main/docs/platform.md)
