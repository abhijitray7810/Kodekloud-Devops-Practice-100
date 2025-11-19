# AWS Key Pair Creation with Terraform

## Overview

This Terraform configuration creates an AWS EC2 key pair for the Nautilus DevOps team's incremental cloud migration strategy. The key pair will be used for secure SSH access to AWS EC2 instances.

## Prerequisites

Before running this Terraform configuration, ensure you have:

- **Terraform** installed (version 1.0 or later)
- **AWS CLI** configured with appropriate credentials
- **AWS Account** with permissions to create EC2 key pairs
- **VS Code** (or any text editor) for managing the configuration

## Configuration Details

### Resources Created

1. **TLS Private Key** (`tls_private_key.devops_key`)
   - Algorithm: RSA
   - Key size: 4096 bits

2. **AWS Key Pair** (`aws_key_pair.devops_kp`)
   - Name: `devops-kp`
   - Type: RSA
   - Region: us-east-1 (configurable)

3. **Local Private Key File** (`local_file.private_key`)
   - Location: `/home/bob/devops-kp.pem`
   - Permissions: 0400 (read-only for owner)

## Directory Structure

```
/home/bob/terraform/
├── main.tf              # Main Terraform configuration
└── README.md            # This file

/home/bob/
└── devops-kp.pem        # Generated private key (after apply)
```

## Setup Instructions

### Step 1: Configure AWS Credentials

Ensure your AWS credentials are configured. You can verify this by running:

```bash
aws configure list
```

If not configured, run:

```bash
aws configure
```

Enter your AWS Access Key ID, Secret Access Key, default region, and output format.

### Step 2: Navigate to Terraform Directory

Open VS Code's integrated terminal (right-click under EXPLORER section and select "Open in Integrated Terminal"), then:

```bash
cd /home/bob/terraform
```

### Step 3: Initialize Terraform

Download the required provider plugins:

```bash
terraform init
```

**Expected Output:**
```
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 5.0"...
- Installing hashicorp/aws...
Terraform has been successfully initialized!
```

### Step 4: Validate Configuration

Check for syntax errors:

```bash
terraform validate
```

### Step 5: Review Execution Plan

Preview the resources that will be created:

```bash
terraform plan
```

Review the output to ensure it matches your expectations.

### Step 6: Apply Configuration

Create the resources:

```bash
terraform apply
```

Type `yes` when prompted to confirm the creation.

**Expected Output:**
```
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

key_pair_id = "devops-kp"
key_pair_name = "devops-kp"
private_key_file = "/home/bob/devops-kp.pem"
```

## Verification

### Verify Private Key File

Check that the private key file was created with correct permissions:

```bash
ls -l /home/bob/devops-kp.pem
```

**Expected Output:**
```
-r-------- 1 bob bob 3243 Nov 19 10:30 /home/bob/devops-kp.pem
```

### Verify AWS Key Pair

Confirm the key pair exists in AWS:

```bash
aws ec2 describe-key-pairs --key-names devops-kp
```

**Expected Output:**
```json
{
    "KeyPairs": [
        {
            "KeyPairId": "key-xxxxxxxxxxxxxxxxx",
            "KeyFingerprint": "xx:xx:xx:...",
            "KeyName": "devops-kp",
            "KeyType": "rsa",
            "Tags": []
        }
    ]
}
```

## Usage

### Using the Key Pair with EC2 Instances

When launching an EC2 instance, specify the key pair:

```bash
aws ec2 run-instances \
  --image-id ami-xxxxxxxxxxxxxxxxx \
  --instance-type t2.micro \
  --key-name devops-kp \
  --security-groups my-sg
```

### Connecting to EC2 Instances

Use the private key to SSH into your EC2 instances:

```bash
ssh -i /home/bob/devops-kp.pem ec2-user@<instance-public-ip>
```

## Configuration Options

### Changing the AWS Region

Edit the `main.tf` file and update the provider region:

```hcl
provider "aws" {
  region = "us-west-2"  # Change to your desired region
}
```

Then run `terraform apply` to update the configuration.

### Changing Key Size

To modify the RSA key size, edit the `rsa_bits` parameter in `main.tf`:

```hcl
resource "tls_private_key" "devops_key" {
  algorithm = "RSA"
  rsa_bits  = 2048  # Options: 2048, 4096
}
```

## Maintenance

### Viewing Current State

To see the current Terraform state:

```bash
terraform show
```

### Destroying Resources

To remove all created resources:

```bash
terraform destroy
```

Type `yes` when prompted. **Warning:** This will delete the key pair from AWS and remove the local private key file.

## Troubleshooting

### Error: "Key pair already exists"

If you get an error that the key pair already exists:

1. Delete the existing key pair:
   ```bash
   aws ec2 delete-key-pair --key-name devops-kp
   ```
2. Run `terraform apply` again

### Error: "Permission denied" when creating file

Ensure you have write permissions to `/home/bob/`:

```bash
ls -ld /home/bob/
```

### Error: "No valid credential sources found"

Configure your AWS credentials:

```bash
aws configure
```

## Security Best Practices

1. **Protect the Private Key**: Never share or commit the `.pem` file to version control
2. **Restrict Permissions**: The private key file is automatically set to 0400 (read-only for owner)
3. **Regular Rotation**: Rotate key pairs periodically for enhanced security
4. **Backup**: Store a secure backup of the private key in a safe location
5. **Add to .gitignore**: Ensure `*.pem` is in your `.gitignore` file

## Support

For issues or questions related to:
- **Terraform**: [Terraform Documentation](https://www.terraform.io/docs)
- **AWS Key Pairs**: [AWS EC2 Key Pairs Documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
- **Nautilus DevOps Team**: Contact your team lead or DevOps administrator

## Migration Strategy

This key pair creation is part of the Nautilus DevOps team's incremental AWS migration strategy. By breaking down the migration into smaller, manageable tasks:

- **Risk Mitigation**: Each component can be tested independently
- **Resource Optimization**: Resources are provisioned as needed
- **Better Control**: Easier to track and manage individual components
- **Minimal Disruption**: Gradual migration reduces impact on operations

## Next Steps

After successfully creating the key pair, proceed with:

1. Creating VPC and networking components
2. Setting up security groups
3. Launching EC2 instances using the `devops-kp` key pair
4. Configuring application deployments

## License

Internal use for Nautilus DevOps team.

---

**Last Updated**: November 19, 2025  
**Maintained By**: Nautilus DevOps Team
