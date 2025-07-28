# Terraform Atlantis Demo Repository

## Purpose
This repository demonstrates a complete Atlantis workflow for Terraform infrastructure management, designed for enterprise-grade security and compliance.

## Repository Structure
```
terraform-test/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── modules/
│   └── vpc/
├── atlantis.yaml
├── .github/
│   └── workflows/
└── docs/
```

## Atlantis Workflow
1. **Plan Phase**: Automatic `terraform plan` on PR creation
2. **Review Phase**: Mandatory code review by designated reviewers
3. **Apply Phase**: Manual `atlantis apply` after approval
4. **Audit Trail**: Complete history of infrastructure changes

## Security Features
- Branch protection rules
- Required reviewers
- Signed commits (recommended)
- Secrets management via environment variables
- Least privilege IAM policies

## Getting Started
See [SETUP.md](./docs/SETUP.md) for detailed setup instructions.
