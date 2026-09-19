# Environments

Path: `environments/<env>/platform/<stack>`

These stacks exist in git as leftover AWS cluster Terraform
(networking, EKS, Argo CD). **Terraform CI does not plan or apply
them.** The practice cluster is Linode, not EKS.

Do not run `terraform apply` in these directories against the AWS
account. Do not add them back to `.github/workflows/terraform.yml`.

Service workloads are not defined here. GitOps still writes image tags
into `platform-gitops`; Argo CD on Linode can sync from there.

Backstage will later create **service** stacks under `services/`, not
environment stacks.

Production VPC/EKS is not shipped and is not planned.

## Related

- [Overview](overview.md)
- [Services](services.md)
- [Kubernetes GitOps](https://github.com/developer-experience-DevEX-platform/ci-cd-templates/blob/main/docs/cd/kubernetes-gitops.md)
