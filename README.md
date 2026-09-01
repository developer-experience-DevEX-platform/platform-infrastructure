# Platform Infrastructure

This repository owns shared platform infrastructure and the environment stacks generated or maintained by DevEx automation.

## Architecture

### `modules/aws/`

Reusable, low-level AWS infrastructure building blocks such as VPC, IAM, ECR, EC2, EKS, and Lambda modules.

### `modules/platform/`

Higher-level developer platform capabilities that may compose multiple AWS modules or resources. Examples include:

- `service-container-release`
- `service-kubernetes`
- `service-lambda`

### `environments/`

Actual deployed infrastructure, separated by environment. Within each environment:

- `platform/` contains shared platform infrastructure.
- `services/` contains per-service stacks.

The intended dependency direction is:

```text
environment stack
    ↓
platform module
    ↓
AWS modules/resources
```

Application developers should not directly consume low-level AWS modules. Backstage and platform automation should generate or update service environment stacks.
