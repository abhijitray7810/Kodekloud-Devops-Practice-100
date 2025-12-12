# Datacenter VPC Migration

This Terraform configuration creates a VPC in AWS as part of the Nautilus DevOps infrastructure migration to the cloud.

## Resources Created

- **VPC**: `datacenter-vpc` in `us-east-1` region
- **CIDR Block**: `10.0.0.0/16`
- **DNS Support**: Enabled

## Prerequisites

- Terraform installed
- AWS credentials configured
- AWS CLI (optional)

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the plan:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. Destroy resources (when needed):
   ```bash
   terraform destroy
   ```

## Next Steps

This is the first phase of the migration. Future phases will include:
- Subnets (public/private)
- Internet Gateway
- Route Tables
- Security Groups
- EC2 instances and other resources
