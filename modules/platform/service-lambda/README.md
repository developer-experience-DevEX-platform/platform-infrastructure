# Service Lambda platform module

This opt-in module provisions the GitHub Actions publishing identity for a Lambda-target service. It does not create a Lambda function or execution role and does not affect existing Kubernetes services.

The shared artifact bucket is owned by `bootstrap/aws-account`; callers pass its `lambda_artifact_bucket_name` output into this module. Artifacts use immutable keys:

```text
<service>/<40-character-git-sha>/function.zip
<service>/<40-character-git-sha>/function.zip.sha256
```

The `<service>-github-lambda-release` role can list only `<service>/*` and can get or put objects only beneath that prefix. It has no bucket administration or deletion permissions.

OIDC trust requires all of the following:

- `aud` is `sts.amazonaws.com`
- `sub` is the immutable owner/repository identity on the configured `main` branch
- `job_workflow_ref` is `developer-experience-DevEX-platform/ci-cd-templates/.github/workflows/nodejs-lambda-release.yml@refs/heads/main`

The referenced reusable release workflow is a Phase 3 prerequisite. Until it exists at that exact path on `main`, the role cannot be assumed through another workflow.

The module creates the non-secret repository variables `AWS_REGION`, `AWS_LAMBDA_RELEASE_ROLE_ARN`, and `AWS_LAMBDA_ARTIFACT_BUCKET`. `AWS_REGION` intentionally matches the existing platform variable contract.
