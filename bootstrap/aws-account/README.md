# AWS Account Bootstrap

This stack provisions the foundational AWS resources required before normal platform and service Terraform stacks can run from GitHub Actions:

- A protected, versioned, encrypted S3 bucket for Terraform state
- One account-level GitHub Actions OIDC provider
- The `devex-terraform-plan` read-only pull-request role
- The `devex-terraform-platform` Terraform execution role

It does not create service ECR repositories, service release roles, Kubernetes resources, GitOps resources, deployments, or GitHub repository variables.

## One-time bootstrap lifecycle

This stack is special because its S3 backend and GitHub OIDC execution role do not exist before the first apply. The initial bootstrap therefore cannot depend on either resource.

```text
Initial one-time bootstrap
    ↓
authenticated administrator runs Terraform
    ↓
state bucket created
    ↓
GitHub OIDC provider created
    ↓
Terraform execution role created
```

After bootstrap:

```text
normal infrastructure workflows
    ↓
GitHub OIDC
    ↓
devex-terraform-platform role
    ↓
S3 remote state
    ↓
Terraform plan/apply
```

No AWS credentials belong in Terraform files. The one-time administrator supplies authentication through their execution environment. Normal GitHub Actions workflows obtain short-lived credentials through OIDC.

## Remote state

The S3 bucket has versioning and server-side encryption enabled, blocks all public access, and cannot be force-destroyed while non-empty. No DynamoDB locking table is created.

Normal stacks should use native S3 state locking:

```hcl
terraform {
  backend "s3" {
    use_lockfile = true
  }
}
```

Backend bucket names and state keys should be supplied during `terraform init`. The execution role can read and write state, but it can delete only `.tflock` objects—not Terraform state objects.

## GitHub OIDC trust

One account-level provider for `https://token.actions.githubusercontent.com` is shared by the Terraform execution role, service container release roles, and future GitHub Actions identities.

The Terraform execution role trusts exactly:

```text
repo:<github_owner>@<github_owner_id>/<github_repository>@<github_repository_id>:ref:refs/heads/<github_branch>
```

The audience is `sts.amazonaws.com`. No wildcard repositories or branches are trusted.

The `devex-terraform-plan` role separately trusts only the pull-request subject:

```text
repo:<github_owner>@<github_owner_id>/<github_repository>@<github_repository_id>:pull_request
```

It can read ECR, IAM, OIDC, and Terraform state configuration and can manage only S3 `.tflock` objects. It cannot create, update, or delete infrastructure.

## Terraform execution permissions

The `devex-terraform-platform` role has explicit permissions for the current platform phase:

- Manage ECR repository configuration
- Manage service IAM roles named `*-github-release` and their inline policies
- Read the shared GitHub OIDC provider
- List the state bucket
- Read and write Terraform state objects
- Read, write, and delete only Terraform `.tflock` objects

It does not receive `AdministratorAccess` and cannot delete Terraform state objects.

## Initial use

Run the first apply with administrator authentication available in the shell or CI environment:

```bash
terraform init -backend=false
terraform plan
terraform apply
```

After the outputs are available, configure normal infrastructure workflows to assume `terraform_execution_role_arn` and initialize their S3 backends with `terraform_state_bucket_name` and `use_lockfile = true`.

## GitHub platform configuration

Configure these repository or organization variables for `platform-infrastructure` after bootstrap:

| Variable | Value |
|---|---|
| `AWS_REGION` | `eu-west-2` |
| `TERRAFORM_STATE_BUCKET` | `devex-platform-terraform-state-980829302319` |
| `TERRAFORM_PLAN_ROLE_ARN` | `arn:aws:iam::980829302319:role/devex-terraform-plan` |
| `TERRAFORM_APPLY_ROLE_ARN` | `arn:aws:iam::980829302319:role/devex-terraform-platform` |
| `AWS_GITHUB_OIDC_PROVIDER_ARN` | `arn:aws:iam::980829302319:oidc-provider/token.actions.githubusercontent.com` |

The platform-owned `PLATFORM_GITHUB_TOKEN` secret must also exist for Terraform's GitHub provider. Its value is not stored or documented here.
