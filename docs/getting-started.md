# Getting started

Add infrastructure for one container service in one sitting. The stack
is a thin caller. You do not copy IAM, ECR, or OIDC into the service
repository.

Application developers skip this page. They keep a Dockerfile and the
CI/CD callers. Backstage and platform automation add the stack here.

## 1. Add a stack

Create `services/<service>/` with the same files as
`services/golden-path-final-test`.

`main.tf`:

```hcl
module "container_release" {
  source = "git::https://github.com/developer-experience-DevEX-platform/terraform-modules.git//platform/service-container-release?ref=v0.3.0"

  service_name             = var.service_name
  github_owner             = var.github_owner
  github_owner_id          = var.github_owner_id
  github_repository        = var.github_repository
  github_repository_id     = var.github_repository_id
  github_oidc_provider_arn = var.github_oidc_provider_arn
  aws_region               = var.aws_region
}
```

Replace `v0.3.0` with the tag every other stack uses. Do not use `main`.
Do not source `../../modules/...`. That tree is gone.

The GitHub provider belongs in this stack, not in the module. Copy
`providers.tf` and `backend.tf` from an existing service.

`service_name` and `github_repository` default to the directory name.
CI discovers owner ID, repository ID, and the OIDC provider ARN; do
not put those in the service repo.

## 2. Open a pull request

Terraform CI plans only the stacks you touched. A new directory under
`services/` is a new stack. State key:

```text
services/<service>/terraform.tfstate
```

You are done when the plan creates (or moves) the ECR repository, the
`*-github-release` role, and the three GitHub Actions variables. Merge
applies. A push to `main` in the service repo can then publish.

## 3. Confirm release

Missing `AWS_REGION`, `AWS_RELEASE_ROLE_ARN`, or `ECR_REPOSITORY`
fails Release. Do not skip that job.

## Next

- [How the stacks fit](overview.md)
- [Service stacks](services.md)
- [Module contract](https://github.com/developer-experience-DevEX-platform/terraform-modules/blob/main/docs/platform/service-container-release.md)
- [Container release workflow](https://github.com/developer-experience-DevEX-platform/ci-cd-templates/blob/main/docs/cd/container-release.md)
