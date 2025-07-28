# Atlantis Setup Guide

## Prerequisites
- GitHub repository with admin access
- AWS account with appropriate permissions
- Atlantis server (can be self-hosted or cloud-based)
- GitHub App or Personal Access Token

## Step-by-Step Setup

### 1. Repository Configuration
- [x] Create repository structure
- [x] Add atlantis.yaml configuration
- [x] Create sample Terraform code
- [ ] Set up branch protection rules
- [ ] Add required reviewers

### 2. GitHub Configuration
```bash
# Set up branch protection
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["atlantis/plan"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1}' \
  --field restrictions=null
```

### 3. Atlantis Server Setup
- Install Atlantis server
- Configure GitHub webhook
- Set environment variables
- Configure AWS credentials

### 4. Testing Workflow
1. Create feature branch
2. Make Terraform changes
3. Create pull request
4. Review Atlantis plan output
5. Approve and apply changes

## Security Considerations
- Use least privilege IAM policies
- Enable audit logging
- Implement secrets management
- Regular security reviews
- Monitor for unauthorized changes
