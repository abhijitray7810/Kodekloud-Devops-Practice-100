# Secure DynamoDB with IAM Access Control

## Overview

This Terraform project creates a secure DynamoDB table with fine-grained IAM access control, allowing read-only access from trusted AWS services only. The implementation follows AWS security best practices and the principle of least privilege.

## 🏗️ Infrastructure Components

### DynamoDB Table
- **Name**: `datacenter-table` (configurable via `KKE_TABLE_NAME`)
- **Billing Mode**: Pay-per-request for cost optimization
- **Primary Key**: Single hash key (`id` attribute)
- **Tags**: Environment and management tracking

### IAM Role
- **Name**: `datacenter-role` (configurable via `KKE_ROLE_NAME`)
- **Trusted Services**: Lambda, EC2, ECS Tasks
- **Purpose**: Allows AWS services to assume the role and access DynamoDB

### IAM Policy
- **Name**: `datacenter-readonly-policy` (configurable via `KKE_POLICY_NAME`)
- **Permissions**: Read-only access (GetItem, Scan, Query)
- **Scope**: Restricted to the specific DynamoDB table only
- **Security**: No wildcard permissions, follows least privilege principle

## 📁 Project Structure

```
/home/bob/terraform/
├── main.tf           # Main infrastructure resources
├── variables.tf      # Input variable declarations
├── outputs.tf        # Output value declarations
├── terraform.tfvars  # Variable values
└── README.md         # This documentation
```

## 🚀 Quick Start

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed (version >= 1.0)
- AWS account with IAM permissions

### Deployment Steps

1. **Navigate to project directory:**
   ```bash
   cd /home/bob/terraform
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Validate configuration:**
   ```bash
   terraform validate
   ```

4. **Review execution plan:**
   ```bash
   terraform plan
   ```

5. **Apply infrastructure:**
   ```bash
   terraform apply
   ```

6. **Verify deployment:**
   ```bash
   terraform plan
   ```
   Should return: "No changes. Your infrastructure matches the configuration."

## 🔧 Configuration

### Variables (terraform.tfvars)
```hcl
KKE_TABLE_NAME  = "datacenter-table"
KKE_ROLE_NAME   = "datacenter-role"
KKE_POLICY_NAME = "datacenter-readonly-policy"
```

### Outputs
- `kke_dynamodb_table`: Name of the created DynamoDB table
- `kke_iam_role_name`: Name of the IAM role
- `kke_iam_policy_name`: Name of the IAM policy

## 🔒 Security Features

### Fine-Grained Access Control
- **Read-Only Permissions**: Only GetItem, Scan, and Query actions allowed
- **Resource-Specific**: Policy applies only to the specific DynamoDB table
- **Service Restriction**: Only trusted AWS services can assume the role
- **No Wildcards**: Explicit resource ARNs used for maximum security

### IAM Best Practices
- **Separation of Concerns**: Role and policy are separate resources
- **Least Privilege**: Minimal permissions required for functionality
- **Audit Trail**: All resources are tagged for tracking
- **Reusable Policy**: Policy can be attached to multiple roles if needed

## 🔍 Verification

After deployment, verify your infrastructure:

### AWS Console Verification
1. **DynamoDB Table**: AWS Console → DynamoDB → Tables → `datacenter-table`
2. **IAM Role**: AWS Console → IAM → Roles → `datacenter-role`
3. **IAM Policy**: AWS Console → IAM → Policies → `datacenter-readonly-policy`

### CLI Verification
```bash
# Check DynamoDB table
aws dynamodb describe-table --table-name datacenter-table

# Check IAM role
aws iam get-role --role-name datacenter-role

# Check IAM policy
aws iam get-policy --policy-arn $(terraform output -raw kke_iam_policy_arn)
```

## 🛠️ Usage Examples

### Lambda Function Integration
```python
import boto3
import os

# Lambda function can assume the role to access DynamoDB
def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('datacenter-table')
    
    # Read operations only (GetItem, Scan, Query)
    response = table.get_item(Key={'id': 'example-id'})
    return response
```

### EC2 Instance Profile
```bash
# Create instance profile and attach role
aws iam create-instance-profile --instance-profile-name datacenter-profile
aws iam add-role-to-instance-profile --instance-profile-name datacenter-profile --role-name datacenter-role

# Launch EC2 with the profile
aws ec2 run-instances --image-id ami-12345678 --instance-type t2.micro \
  --iam-instance-profile Name=datacenter-profile
```

## 🧪 Testing

### Test Read Access
```bash
# This should work (read operation)
aws dynamodb get-item --table-name datacenter-table \
  --key '{"id": {"S": "test-id"}}' \
  --return-consumed-capacity TOTAL

# This should fail (write operation - not allowed)
aws dynamodb put-item --table-name datacenter-table \
  --item '{"id": {"S": "test-id"}, "data": {"S": "test-data"}}'
```

## 🚨 Important Notes

### State Management
- Terraform state is stored locally by default
- For production use, configure remote state backend (S3 + DynamoDB)
- State file contains sensitive information - protect it appropriately

### Security Considerations
- Review and understand all IAM permissions before deployment
- Regularly audit IAM roles and policies
- Monitor CloudTrail logs for unauthorized access attempts
- Rotate credentials according to your organization's security policy

### Cost Optimization
- DynamoDB uses pay-per-request billing mode
- No charges for IAM roles and policies
- Costs depend on actual usage of read operations

## 🔧 Troubleshooting

### Common Issues

**Permission Denied Errors**
- Verify the IAM role is correctly assumed by your AWS service
- Check the policy is attached to the role
- Ensure the resource ARN in the policy matches your table

**Table Not Found**
- Verify the table name in your application matches the Terraform output
- Check the AWS region configuration
- Ensure Terraform apply was successful

**Role Assumption Failures**
- Verify the trusted service principal in the role
- Check the service has permission to assume roles
- Review CloudTrail logs for detailed error messages

### Debug Commands
```bash
# Check role trust policy
aws iam get-role --role-name datacenter-role --query 'Role.AssumeRolePolicyDocument'

# Test role assumption (for testing purposes)
aws sts assume-role --role-arn arn:aws:iam::YOUR-ACCOUNT-ID:role/datacenter-role \
  --role-session-name test-session

# Check effective permissions
aws iam simulate-principal-policy --policy-source-arn arn:aws:iam::YOUR-ACCOUNT-ID:role/datacenter-role \
  --action-names dynamodb:GetItem dynamodb:Scan dynamodb:Query \
  --resource-arns $(terraform output -raw kke_dynamodb_table_arn)
```

## 📚 Additional Resources

- [AWS DynamoDB Documentation](https://docs.aws.amazon.com/dynamodb/)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [AWS IAM Policy Reference](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html)

## 🤝 Contributing

1. Review the current infrastructure for any security improvements
2. Test changes in a development environment first
3. Update documentation for any new features or changes
4. Follow Terraform best practices and conventions

## 📄 License

This project is part of the Nautilus DevOps infrastructure and should be used according to your organization's policies and AWS best practices.

---

**Note**: Always review and test infrastructure changes in a non-production environment before applying to production systems.
