# IAM Policy for EC2 Read-Only Access

## Overview

This Terraform configuration creates an IAM policy named `iampolicy_mariyam` that provides read-only access to the AWS EC2 console. Users assigned this policy can view all EC2 instances, AMIs (Amazon Machine Images), and snapshots without the ability to modify them.

## Prerequisites

- Terraform installed (version compatible with AWS provider ~> 5.0)
- AWS CLI configured with appropriate credentials
- Sufficient IAM permissions to create IAM policies

## Project Structure

```
/home/bob/terraform/
├── main.tf       # Main Terraform configuration file
└── README.md     # This documentation file
```

## Configuration Details

### Provider
- **Region**: us-east-1
- **AWS Provider Version**: ~> 5.0

### IAM Policy
- **Name**: iampolicy_mariyam
- **Description**: Read-only access to EC2 console

### Permissions Granted

The policy allows the following actions:

| Action | Description |
|--------|-------------|
| `ec2:Describe*` | View all EC2 resources (instances, AMIs, snapshots, volumes, etc.) |
| `ec2:GetConsole*` | Retrieve console screenshots and output |
| `ec2:GetPasswordData` | Get Windows instance administrator password |
| `ec2:GetSerialConsoleAccessStatus` | Check serial console access status |
| `ec2:SearchTransitGatewayRoutes` | Search transit gateway routes |

### Resource Scope
- **Resource**: `*` (All EC2 resources)

## Deployment Instructions

### Step 1: Navigate to Working Directory

```bash
cd /home/bob/terraform
```

### Step 2: Initialize Terraform

Initialize the Terraform working directory and download required providers:

```bash
terraform init
```

### Step 3: Validate Configuration

Validate the syntax and configuration:

```bash
terraform validate
```

### Step 4: Review Execution Plan

Preview the changes that will be made:

```bash
terraform plan
```

### Step 5: Apply Configuration

Create the IAM policy:

```bash
terraform apply
```

Type `yes` when prompted to confirm the action.

### Step 6: Verify Creation

After successful deployment, Terraform will output:
- Policy ARN
- Policy Name

You can also verify in the AWS Console:
1. Navigate to IAM → Policies
2. Search for `iampolicy_mariyam`
3. Review the policy document

## Outputs

The configuration provides the following outputs:

- **policy_arn**: The Amazon Resource Name (ARN) of the created policy
- **policy_name**: The name of the created policy

## Attaching the Policy

### To a User

```bash
aws iam attach-user-policy \
  --user-name <username> \
  --policy-arn <policy-arn-from-output>
```

### To a Group

```bash
aws iam attach-group-policy \
  --group-name <groupname> \
  --policy-arn <policy-arn-from-output>
```

### To a Role

```bash
aws iam attach-role-policy \
  --role-name <rolename> \
  --policy-arn <policy-arn-from-output>
```

## Cleanup

To remove the IAM policy:

```bash
terraform destroy
```

**Note**: You must detach the policy from all users, groups, and roles before destroying it.

## Security Considerations

- This policy grants **read-only** access and does not allow any modifications to EC2 resources
- Users with this policy cannot launch, terminate, or modify EC2 instances
- The policy follows the principle of least privilege for viewing EC2 resources
- Regularly review and audit who has this policy attached

## Troubleshooting

### Issue: "Error: creating IAM Policy - EntityAlreadyExists"
**Solution**: A policy with this name already exists. Either delete the existing policy or change the name in `main.tf`.

### Issue: "Error: insufficient permissions"
**Solution**: Ensure your AWS credentials have `iam:CreatePolicy` permission.

### Issue: Terraform not found
**Solution**: Install Terraform from [terraform.io](https://www.terraform.io/downloads)

## Additional Resources

- [AWS IAM Policies Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [EC2 IAM Actions](https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazonec2.html)

## Author

Nautilus DevOps Team

## Version

1.0.0
