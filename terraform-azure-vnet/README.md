# Terraform Azure VNET Project

This project demonstrates provisioning Azure infrastructure using Terraform with a reusable VNET module and multiple environments (dev and prod).

## Structure
- modules/vnet: Reusable VNET module
- environments/dev: Development environment configuration
- environments/prod: Production environment configuration
- .github/workflows: GitHub Actions CI/CD pipeline

## How to Use
1. Navigate to the desired environment folder (dev or prod).
2. Run `terraform init`, `terraform plan`, and `terraform apply`.
3. Ensure you have Azure credentials configured.

## Tools for Clean Code
- terraform fmt
- terraform validate
- tflint
- pre-commit hooks
- terraform-docs for automated documentation
