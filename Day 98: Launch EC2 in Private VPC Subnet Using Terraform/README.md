# AWS Private VPC Infrastructure with Terraform

## Overview

This Terraform configuration creates a secure, private AWS Virtual Private Cloud (VPC) infrastructure with an isolated subnet and EC2 instance. The setup ensures that resources remain completely private and can only communicate within the VPC, providing enhanced security for your cloud deployments.

## 🏗️ Architecture

```plaintext
┌─────────────────────────────────────────────────────────────────┐
│                        AWS Cloud                                 │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                 Private VPC (10.0.0.0/16)                    │ │
│  │  ┌───────────────────────────────────────────────────────┐  │ │
│  │  │              Private Subnet (10.0.1.0/24)              │  │ │
│  │  │  ┌─────────────────────────────────────────────────┐  │  │ │
│  │  │  │          EC2 Instance (t2.micro)                 │  │  │ │
│  │  │  │         Name: datacenter-priv-ec2                │  │  │ │
│  │  │  │         Access: VPC Internal Only                │  │  │ │
│  │  │  └─────────────────────────────────────────────────┘  │  │ │
│  │  │  ┌─────────────────────────────────────────────────┐  │  │ │
│  │  │  │     Security Group (VPC CIDR Only)              │  │  │ │
│  │  │  │  • Ingress: Allow from 10.0.0.0/16 only         │  │  │ │
│  │  │  │  • Egress: Allow all outbound                   │  │  │ │
│  │  │  └─────────────────────────────────────────────────┘  │  │ │
│  │  └───────────────────────────────────────────────────────┘  │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## 📋 Components

### VPC Configuration
- **VPC Name**: `datacenter-priv-vpc`
- **CIDR Block**: `10.0.0.0/16` (65,536 IP addresses)
- **DNS Support**: Enabled
- **DNS Hostnames**: Enabled

### Subnet Configuration
- **Subnet Name**: `datacenter-priv-subnet`
- **CIDR Block**: `10.0.1.0/24` (256 IP addresses)
- **Auto-assign Public IP**: Disabled (ensures complete privacy)
- **Type**: Private subnet

### EC2 Instance
- **Instance Name**: `datacenter-priv-ec2`
- **Instance Type**: `t2.micro` (AWS Free Tier eligible)
- **AMI**: Amazon Linux 2
- **Placement**: Private subnet only
- **Public IP**: None assigned

### Security Group
- **Name**: `datacenter-priv-sg`
- **Ingress Rules**: Allow all traffic only from VPC CIDR (10.0.0.0/16)
- **Egress Rules**: Allow all outbound traffic
- **State**: Stateful (return traffic automatically allowed)

## 🚀 Quick Start

### Prerequisites
- AWS CLI installed and configured
- Terraform >= 1.0 installed
- AWS account with appropriate permissions
- IAM user with VPC and EC2 permissions

### Installation Steps

1. **Clone or navigate to the project directory**
```bash
cd /home/bob/terraform
```

2. **Create the Terraform configuration files**
Create the following files with the provided content:
- `variables.tf`
- `main.tf`
- `outputs.tf`

3. **Initialize Terraform**
```bash
terraform init
```

4. **Review the planned changes**
```bash
terraform plan
```

5. **Apply the configuration**
```bash
terraform apply
```

6. **Verify the outputs**
```bash
terraform output
```

## 📁 File Structure

```
/home/bob/terraform/
├── variables.tf      # Input variables configuration
├── main.tf          # Main infrastructure resources
├── outputs.tf       # Output values
└── README.md        # This documentation
```

## ⚙️ Configuration Details

### Variables (variables.tf)

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `KKE_VPC_CIDR` | VPC CIDR block | `10.0.0.0/16` |
| `KKE_SUBNET_CIDR` | Subnet CIDR block | `10.0.1.0/24` |
| `region` | AWS region | `us-east-1` |
| `instance_type` | EC2 instance type | `t2.micro` |
| `ami_id` | AMI ID for EC2 instance | Amazon Linux 2 |

### Outputs (outputs.tf)

| Output | Description |
|--------|-------------|
| `KKE_vpc_name` | Name of the created VPC |
| `KKE_subnet_name` | Name of the created subnet |
| `KKE_ec2_private` | Name of the created EC2 instance |
| `vpc_id` | ID of the created VPC |
| `subnet_id` | ID of the created subnet |
| `ec2_instance_id` | ID of the created EC2 instance |
| `ec2_private_ip` | Private IP address of the EC2 instance |

## 🔒 Security Features

### Network Isolation
- **Private VPC**: Complete network isolation from other AWS customers
- **Private Subnet**: No internet gateway or NAT gateway attached
- **No Public IPs**: EC2 instance has no public IP assignment

### Access Control
- **Security Group**: Only allows inbound traffic from within the VPC
- **CIDR-based Filtering**: Strict ingress rules based on VPC CIDR block
- **Stateful Rules**: Automatic return traffic allowance

### Best Practices Implemented
- Principle of least privilege
- Network segmentation
- Resource isolation
- Proper tagging strategy

## 🛠️ Usage Instructions

### Accessing the Private Instance

Since the EC2 instance is in a private subnet with no public IP, you can access it using:

1. **AWS Systems Manager Session Manager** (Recommended)
   - No SSH keys required
   - No bastion host needed
   - Secure and auditable

2. **Bastion Host Setup** (Optional)
   - Create a bastion host in a public subnet
   - Use SSH tunneling through the bastion
   - Configure proper security groups

### Connecting Resources

To connect additional resources to this private infrastructure:

1. **Create additional subnets** within the same VPC
2. **Configure security groups** to allow inter-subnet communication
3. **Use private IP addresses** for internal communication

## 📊 Monitoring and Logging

### Enable VPC Flow Logs
Add this to your configuration to monitor network traffic:
```hcl
resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.datacenter_priv_vpc.id
}
```

### CloudWatch Integration
- Monitor EC2 instance metrics
- Set up alarms for resource utilization
- Enable detailed monitoring for enhanced visibility

## 🔧 Maintenance

### Updating the Configuration
1. Modify the appropriate `.tf` file
2. Run `terraform plan` to review changes
3. Run `terraform apply` to implement changes

### Backup Strategy
- **State Management**: Use remote state backend (S3 + DynamoDB)
- **Resource Backups**: Create AMIs of important instances
- **Configuration Versioning**: Use Git for infrastructure code

## 🚨 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| `terraform plan` shows no changes | Check AWS credentials and region configuration |
| EC2 instance not accessible | Verify security group rules and subnet configuration |
| VPC creation fails | Check CIDR block conflicts and IAM permissions |
| Subnet creation fails | Verify CIDR block is within VPC CIDR range |

### Debugging Commands
```bash
# Check Terraform state
terraform state list

# View current configuration
terraform show

# Refresh state
terraform refresh

# Enable detailed logging
export TF_LOG=DEBUG
```

## 💰 Cost Optimization

### Free Tier Eligible
- **t2.micro instance**: 750 hours/month for 12 months
- **VPC**: No additional charges
- **Subnet**: No additional charges
- **Security Groups**: No additional charges

### Cost Considerations
- **Data Transfer**: Internal VPC traffic is free
- **Storage**: EBS volumes incur charges
- **Monitoring**: CloudWatch logs incur charges after free tier

## 🧹 Cleanup

To destroy all resources and avoid ongoing charges:
```bash
terraform destroy
```

**⚠️ Warning**: This will permanently delete all resources. Ensure you have backed up any important data before proceeding.

## 📚 Additional Resources

### AWS Documentation
- [AWS VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/)
- [AWS Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)
- [AWS EC2 Instance Types](https://aws.amazon.com/ec2/instance-types/)

### Terraform Resources
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/language/index.html)
- [Terraform State Management](https://www.terraform.io/docs/language/state/index.html)

## 🤝 Contributing

To improve this configuration:
1. Test changes in a development environment first
2. Follow Terraform best practices
3. Document any new features or changes
4. Ensure security best practices are maintained

## 📄 License

This Terraform configuration is provided as-is for educational and development purposes. Ensure you review and understand all security implications before using in production environments.

---

