# Services

Path: `services/<service>`

One Terraform root per GitHub service repository. State key:

```text
services/<service>/terraform.tfstate
```

Directory name, `service_name`, and `github_repository` match.

## Container services

Call `platform/service-container-release`. Available.

| Stack | Service repo |
| --- | --- |
| `golden-path-final-test` | golden-path-final-test |
| `pipeline-end-end-test` | pipeline-end-end-test |
| `nodejs-secret-golden-path-test` | nodejs-secret-golden-path-test |

Creates ECR (via `aws/ecr` inside the module),
`<service>-github-release`, GitHub variables, and the `production`
environment. Developers do not create those by hand.

Paste: [getting started](getting-started.md).

## Lambda services

Call `platform/service-lambda`. Exists. Lambda CD in
`ci-cd-templates` is not reviewed yet.

| Stack | Service repo |
| --- | --- |
| `nodejs-lambda-golden-path-test` | nodejs-lambda-golden-path-test |

Needs `lambda_artifact_bucket_name` from bootstrap and
`initial_artifact_key`. Prefer a container service for a new
golden-path app.

## CI

`.github/workflows/terraform.yml` detects `services/<name>` from the
diff. For those stacks it looks up GitHub owner ID and repository ID
and passes:

- `TF_VAR_github_owner`
- `TF_VAR_github_repository`
- `TF_VAR_github_owner_id`
- `TF_VAR_github_repository_id`
- `TF_VAR_github_oidc_provider_arn`

Pull requests assume `TERRAFORM_PLAN_ROLE_ARN`. Push to `main` assumes
`TERRAFORM_APPLY_ROLE_ARN`. Networking, EKS, and Argo CD are not in
this workflow. The cluster is Linode.

## Related

- [Container release module](https://github.com/developer-experience-DevEX-platform/terraform-modules/blob/main/docs/platform/service-container-release.md)
- [Lambda service module](https://github.com/developer-experience-DevEX-platform/terraform-modules/blob/main/docs/platform/service-lambda.md)
- [CI/CD container release](https://github.com/developer-experience-DevEX-platform/ci-cd-templates/blob/main/docs/cd/container-release.md)
