# Nautilus EC2 Instance Deployment

This Terraform configuration provisions an EC2 instance on AWS as part of the Nautilus DevOps team's incremental cloud migration strategy.

## Overview

This project creates a single EC2 instance with the following specifications:
- **Instance Name**: nautilus-ec2
- **AMI**: Amazon Linux (ami-0c101f26f147fa7fd)
- **Instance Type**: t2.micro
- **Key Pair**: nautilus-kp (RSA)
- **Security Group**: Default VPC security group

## Prerequisites

Before you begin, ensure you have:
- Terraform installed (version 1.0 or later recommended)
- AWS CLI configured with appropriate credentials
- AWS account with permissions to create EC2 instances, key pairs, and access VPC resources
- Access to the us-east-1 region (or modify the region in main.tf)

## Directory Structure

```
/home/bob/terraform/
├── main.tf           # Main Terraform configuration
├── README.md         # This file
└── nautilus-kp.pem   # Generated private key (created after apply)
```

## Configuration Details

### Resources Created

1. **TLS Private Key**: RSA 4096-bit key pair
2. **AWS Key Pair**: nautilus-kp (uses the generated public key)
3. **EC2 Instance**: nautilus-ec2 with specified AMI and instance type
4. **Local File**: Private key saved as nautilus-kp.pem

### Data Sources Used

- Default VPC
- Default Security Group

## Deployment Instructions

### Step 1: Open Terminal

In VS Code, right-click under the EXPLORER section and select **"Open in Integrated Terminal"**.

### Step 2: Navigate to Terraform Directory

```bash
cd /home/bob/terraform
```

### Step 3: Initialize Terraform

Download the required providers and initialize the working directory:

```bash
terraform init
```

### Step 4: Validate Configuration

Check the configuration for syntax errors:

```bash
terraform validate
```

### Step 5: Preview Changes

Review the resources that will be created:

```bash
terraform plan
```

### Step 6: Apply Configuration

Create the resources:

```bash
terraform apply
```

When prompted, type `yes` to confirm.

### Step 7: Review Outputs

After successful deployment, Terraform will display:
- Instance ID
- Public IP address
- Public DNS name
- Private key file path

## Connecting to Your Instance

Once the instance is running, connect via SSH:

```bash
# Ensure the private key has correct permissions
chmod 400 nautilus-kp.pem

# Connect to the instance
ssh -i nautilus-kp.pem ec2-user@<INSTANCE_PUBLIC_IP>
```

Replace `<INSTANCE_PUBLIC_IP>` with the actual IP address shown in the Terraform outputs.

## Managing Your Infrastructure

### View Current State

```bash
terraform show
```

### List Resources

```bash
terraform state list
```

### Get Resource Details

```bash
terraform state show aws_instance.nautilus_ec2
```

### Modify Infrastructure

1. Edit the `main.tf` file
2. Run `terraform plan` to preview changes
3. Run `terraform apply` to apply changes

### Destroy Resources

When you no longer need the infrastructure:

```bash
terraform destroy
```

Type `yes` when prompted to confirm deletion.

## Outputs

The configuration provides the following outputs:

| Output | Description |
|--------|-------------|
| instance_id | The unique ID of the EC2 instance |
| instance_public_ip | Public IPv4 address for SSH access |
| instance_public_dns | Public DNS name of the instance |
| private_key_path | Local path to the private key file |

## Security Considerations

- The private key file (`nautilus-kp.pem`) is created with 0400 permissions (read-only for owner)
- **Important**: Keep the private key secure and never commit it to version control
- The instance uses the default security group - review and adjust rules as needed for your use case
- Consider implementing additional security measures such as:
  - Restricting SSH access to specific IP addresses
  - Using AWS Systems Manager Session Manager instead of SSH
  - Implementing additional security groups with least-privilege rules

## Troubleshooting

### Common Issues

**Issue**: `Error: No valid credential sources found`
**Solution**: Configure AWS credentials using `aws configure` or set environment variables

**Issue**: `Error: creating EC2 Instance: UnauthorizedOperation`
**Solution**: Ensure your AWS user/role has permissions to create EC2 instances

**Issue**: `Error: InvalidAMIID.NotFound`
**Solution**: Verify the AMI ID is available in your selected region

**Issue**: Permission denied when connecting via SSH
**Solution**: Ensure the private key has correct permissions: `chmod 400 nautilus-kp.pem`

## Customization

To customize this configuration:

1. **Change Region**: Modify the `region` parameter in the provider block
2. **Change Instance Type**: Update the `instance_type` parameter
3. **Use Different AMI**: Replace the `ami` value with your desired AMI ID
4. **Add Tags**: Add more tags in the `tags` block of the EC2 instance resource

## Best Practices

- Always run `terraform plan` before `terraform apply`
- Use version control for your Terraform files (exclude `.tfstate` and `*.pem` files)
- Store Terraform state remotely for team collaboration (e.g., S3 backend)
- Implement proper backup and disaster recovery procedures
- Document any customizations or deviations from this configuration

## Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Terraform CLI Documentation](https://www.terraform.io/docs/cli)

## Support

For issues or questions related to this deployment:
- Contact the Nautilus DevOps team
- Review Terraform and AWS documentation
- Check AWS CloudTrail logs for detailed error information

## Version History

- **v1.0**: Initial configuration with basic EC2 instance setup

---

**Note**: This is part of the Nautilus incremental cloud migration project. Each component is designed to be deployed and managed independently.
