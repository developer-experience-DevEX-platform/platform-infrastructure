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

All stacks in this repository should share one tag. Today that tag is
`v0.3.0`. Bump every `?ref=` together after you cut a module release.

Existing AWS resources must `moved`, not recreate. Do not delete a
repository or role in order to point a stack at a new module path.

## Terraform CI

Workflow: `.github/workflows/terraform.yml`

Triggers on changes under `services/`, `environments/`, or the
workflow file itself. Bootstrap is applied by an administrator; see
[bootstrap](bootstrap.md).

| Event | Role | What runs |
| --- | --- | --- |
| Pull request | `devex-terraform-plan` | `fmt`, `init`, `validate`, `plan` per affected stack |
| Push to `main` | `devex-terraform-platform` | same, then `apply` |

If only the workflow file changes, every service and environment stack
is planned. Bootstrap is not in that matrix; see
[bootstrap](bootstrap.md).

Argo CD PRs Helm-lint instead of planning against the cluster. Details:
[environments](environments.md).

Unsupported environment directory names fail the detect job. Only
`staging` and `production` are allowed under `environments/`.

## Providers

Every stack configures providers. Service stacks need AWS and GitHub:

```hcl
provider "aws" {
  region = var.aws_region
}

provider "github" {
  owner = var.github_owner
}
```

`GITHUB_TOKEN` in CI is `PLATFORM_GITHUB_TOKEN`. Environment stacks
that only call `aws/*` need AWS.

Terraform in CI is `1.13.5`.

## GitHub identities

Numeric owner and repository IDs are immutable. The plan/apply
workflow discovers them with `gh api`. Do not trust a renamed slug
alone in OIDC `sub`.

The account OIDC provider is bootstrap. Its ARN is
`vars.AWS_GITHUB_OIDC_PROVIDER_ARN`.

## Related

- [terraform-modules platform notes](https://github.com/developer-experience-DevEX-platform/terraform-modules/blob/main/docs/platform.md)
- [CI/CD platform notes](https://github.com/developer-experience-DevEX-platform/ci-cd-templates/blob/main/docs/platform.md)
