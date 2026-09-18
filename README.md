# Platform Infrastructure

This repository owns deployed platform and service stacks. Reusable modules live in [`terraform-modules`](https://github.com/developer-experience-DevEX-platform/terraform-modules) and are pinned by git tag.

```text
bootstrap / environments / services
        ↓
terraform-modules/platform/*     (service OIDC, GitHub, IAM)
        ↓
terraform-modules/aws/*          (s3, ecr, networking, eks, lambda)
```

Application developers should not call `aws` modules. Backstage and platform automation generate service stacks that call `platform` modules.
