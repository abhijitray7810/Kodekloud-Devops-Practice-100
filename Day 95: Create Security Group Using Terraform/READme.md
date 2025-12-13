# Nautilus AWS Security Group Terraform Configuration

## Overview

This Terraform configuration creates a security group for the Nautilus App Servers as part of the incremental AWS cloud migration strategy. The security group is configured with HTTP and SSH access rules to support application deployment and server management.

## Project Structure

```
/home/bob/terraform/
├── main.tf          # Main Terraform configuration file
└── README.md        # This documentation file
```

## Prerequisites

Before running this Terraform configuration, ensure you have:

1. **Terraform installed** (version compatible with AWS provider ~> 5.0)
2. **AWS CLI configured** with valid credentials
3. **Appropriate AWS IAM permissions** to:
   - Create security groups
   - Access VPC information
   - Manage EC2 resources
4. **Default VPC** available in the us-east-1 region

## Configuration Details

### Security Group Specifications

- **Name**: `nautilus-sg`
- **Description**: Security group for Nautilus App Servers
- **VPC**: Default VPC in us-east-1 region
- **Region**: us-east-1

### Inbound Rules

| Type | Protocol | Port | Source CIDR | Description |
|------|----------|------|-------------|-------------|
| HTTP | TCP | 80 | 0.0.0.0/0 | HTTP access from anywhere |
| SSH | TCP | 22 | 0.0.0.0/0 | SSH access from anywhere |

### Outbound Rules

- **All traffic** is allowed to any destination (0.0.0.0/0)

## Deployment Instructions

### Step 1: Navigate to the Terraform Directory

Open the integrated terminal in VS Code by right-clicking under the EXPLORER section and selecting "Open in Integrated Terminal", then run:

```bash
cd /home/bob/terraform
```

### Step 2: Initialize Terraform

Initialize the Terraform working directory and download the required AWS provider:

```bash
terraform init
```

Expected output: Terraform will download the AWS provider plugin and initialize the backend.

### Step 3: Review the Execution Plan

Preview the changes that Terraform will make:

```bash
terraform plan
```

This command shows you what resources will be created without actually creating them.

### Step 4: Apply the Configuration

Create the security group:

```bash
terraform apply
```

When prompted, review the plan and type `yes` to confirm.

### Step 5: Verify the Outputs

After successful deployment, Terraform will display:
- Security group ID
- Security group name

## Post-Deployment Verification

### Using AWS CLI

Verify the security group was created:

```bash
aws ec2 describe-security-groups --group-names nautilus-sg --region us-east-1
```

### Using AWS Console

1. Navigate to the AWS Console
2. Go to EC2 → Security Groups
3. Search for `nautilus-sg`
4. Verify the inbound rules for HTTP (port 80) and SSH (port 22)

## Managing the Infrastructure

### View Current State

```bash
terraform show
```

### Update Configuration

1. Modify `main.tf` as needed
2. Run `terraform plan` to preview changes
3. Run `terraform apply` to apply changes

### Destroy Resources

To remove the security group when no longer needed:

```bash
terraform destroy
```

Type `yes` when prompted to confirm deletion.

## Security Considerations

⚠️ **Important Security Notes:**

- The current configuration allows SSH and HTTP access from **any IP address** (0.0.0.0/0)
- For production environments, consider restricting source CIDR blocks to specific IP ranges
- Regularly review and audit security group rules
- Consider implementing additional security measures like:
  - VPN or bastion host for SSH access
  - Application Load Balancer for HTTP traffic
  - AWS Security Groups with more restrictive rules

## Troubleshooting

### Common Issues

**Issue**: `Error: No default VPC found`
- **Solution**: Ensure a default VPC exists in us-east-1 region or modify the configuration to use a specific VPC ID

**Issue**: `Error: AccessDenied`
- **Solution**: Verify AWS credentials have sufficient permissions to create security groups

**Issue**: `Error: Security group with name 'nautilus-sg' already exists`
- **Solution**: Either delete the existing security group or import it into Terraform state using:
  ```bash
  terraform import aws_security_group.nautilus_sg sg-xxxxxxxxx
  ```

### Getting Help

- Check Terraform documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- Review AWS security group best practices
- Contact the Nautilus DevOps team for project-specific guidance

## Migration Context

This security group is part of the Nautilus team's incremental AWS migration strategy. By breaking down the migration into smaller, manageable tasks, the team can:

- Minimize disruption to ongoing operations
- Better control and mitigate risks
- Optimize resource allocation throughout the migration process
- Systematically progress through each migration stage

## Next Steps

After successfully creating this security group, consider:

1. Creating EC2 instances and associating them with this security group
2. Setting up additional security groups for different application tiers
3. Implementing network ACLs for additional security layers
4. Documenting the complete infrastructure architecture
5. Setting up monitoring and alerting for security group changes

## Version History

- **v1.0.0** - Initial security group configuration with HTTP and SSH access

## Contributors

Nautilus DevOps Team

---

**Last Updated**: December 2025
