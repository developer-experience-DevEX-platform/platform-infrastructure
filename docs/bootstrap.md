# Bootstrap

Stack: `bootstrap/aws-account`

Foundational AWS objects required before other stacks can run from
GitHub Actions:

- Terraform state bucket (`aws/s3`)
- Shared Lambda artifact bucket (`aws/s3`)
- Shared TechDocs bucket (`aws/s3`)
- Account-level GitHub Actions OIDC provider
- `devex-terraform-plan` (read-only, pull requests)
- `devex-terraform-platform` (apply on `main`)

It does not create service ECR repositories, Lambda functions, service
release roles, Kubernetes resources, GitOps resources, or GitHub
repository variables. It also does not create a VPC or EKS; the
practice cluster is Linode.

This stack is **not** in the normal Terraform CI matrix. The first
apply cannot use the S3 backend or OIDC role it creates.

## One-time lifecycle

```text
authenticated administrator
    ↓
terraform init -backend=false
    ↓
state bucket, OIDC provider, plan/apply roles
```

After that:

```text
GitHub Actions
    ↓
OIDC → plan or apply role
    ↓
S3 remote state
    ↓
terraform plan / apply
```

No AWS credentials belong in Terraform files.

## Lambda artifact store

Bucket name: `devex-lambda-artifacts-<account-id>`. Locked S3 defaults
come from `aws/s3`. Immutable keys:

```text
<service-name>/<40-character-git-sha>/function.zip
<service-name>/<40-character-git-sha>/function.zip.sha256
```

There is no `latest` object. `platform/service-lambda` grants each
service access only to `<service-name>/*`.

## TechDocs store

Bucket name: `devex-techdocs-<account-id>`. Locked S3 defaults come
from `aws/s3`. Generated sites use Backstage's key layout:

```text
default/component/<service-name>/
```

This stack only creates the bucket. Service write prefixes, the GitHub
publish workflow, and the Backstage read role come in later slices.

## Remote state

Versioning and encryption are on. Public access is blocked.
`force_destroy` is off. No DynamoDB lock table.

Normal stacks:

```hcl
terraform {
  backend "s3" {
    use_lockfile = true
  }
}
```

Bucket and key are supplied at `terraform init`. The execution role can
read and write state. It can delete only `.tflock` objects, not state
objects.

## OIDC trust

One provider: `https://token.actions.githubusercontent.com`. Shared by
Terraform and service release roles.

Apply role `sub`:

```text
repo:<owner>@<owner_id>/<repo>@<repo_id>:ref:refs/heads/<branch>
```

Plan role `sub`:

```text
repo:<owner>@<owner_id>/<repo>@<repo_id>:pull_request
```

Audience is `sts.amazonaws.com`. No wildcard repositories or branches.

The plan role can read ECR, IAM, OIDC, and state, and can manage S3
`.tflock` objects. It cannot create or delete infrastructure.

The apply role can manage ECR, `*-github-release` roles, the shared
OIDC provider lookup, and state. It does not get `AdministratorAccess`
and cannot delete state objects.

## First apply

```bash
cd bootstrap/aws-account
terraform init -backend=false
terraform plan
terraform apply
```

Then set these on `platform-infrastructure`:

| Variable | Example |
| --- | --- |
| `AWS_REGION` | `eu-west-2` |
| `TERRAFORM_STATE_BUCKET` | `devex-platform-terraform-state-980829302319` |
| `TERRAFORM_PLAN_ROLE_ARN` | `arn:aws:iam::980829302319:role/devex-terraform-plan` |
| `TERRAFORM_APPLY_ROLE_ARN` | `arn:aws:iam::980829302319:role/devex-terraform-platform` |
| `AWS_GITHUB_OIDC_PROVIDER_ARN` | `arn:aws:iam::980829302319:oidc-provider/token.actions.githubusercontent.com` |

`PLATFORM_GITHUB_TOKEN` is an org/repo secret for the GitHub provider.
Its value is not stored here.
