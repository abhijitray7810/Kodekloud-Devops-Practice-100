# Terraform Configuration for EC2 Instance and CloudWatch Alarm

## Overview

This Terraform configuration creates an AWS EC2 instance with a CloudWatch alarm to monitor CPU utilization. The alarm triggers when CPU usage exceeds 90% for one consecutive 5-minute period and sends notifications to an existing SNS topic.

## Prerequisites

1. **AWS Account** with appropriate permissions
2. **AWS CLI** configured with valid credentials
3. **Terraform** installed (version 1.0.0 or later recommended)
4. **Existing SNS Topic**: Ensure the SNS topic named `datacenter-sns-topic` exists in your AWS account

## Architecture

The configuration creates:
- **EC2 Instance**: Ubuntu-based instance using AMI `ami-0c02fb55956c7d316`
- **CloudWatch Alarm**: Monitors CPU utilization with specific thresholds
- **SNS Integration**: Uses existing SNS topic for notifications

## Files Structure

```
/home/bob/terraform/
├── main.tf          # Main Terraform configuration
├── outputs.tf       # Output definitions
└── README.md        # This documentation
```

## Configuration Details

### main.tf
Contains the main infrastructure definition:
- AWS provider configuration
- EC2 instance resource (`datacenter-ec2`)
- Data source for existing SNS topic
- CloudWatch alarm resource (`datacenter-alarm`)

### outputs.tf
Defines the following outputs:
- `KKE_instance_name`: Name of the EC2 instance
- `KKE_alarm_name`: Name of the CloudWatch alarm

## Resource Specifications

### EC2 Instance
- **Name**: `datacenter-ec2`
- **AMI**: `ami-0c02fb55956c7d316` (Ubuntu)
- **Instance Type**: `t2.micro`
- **Region**: `us-east-1` (modifiable in provider configuration)

### CloudWatch Alarm
- **Name**: `datacenter-alarm`
- **Metric**: CPUUtilization
- **Namespace**: AWS/EC2
- **Statistic**: Average
- **Threshold**: 90%
- **Period**: 300 seconds (5 minutes)
- **Evaluation Periods**: 1
- **Comparison Operator**: GreaterThanOrEqualToThreshold
- **Alarm Actions**: Sends notification to `datacenter-sns-topic`

## Usage

### Initial Setup
```bash
cd /home/bob/terraform
terraform init
```

### Plan Deployment
```bash
terraform plan
```

### Apply Configuration
```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

### Verify Deployment
```bash
terraform show
```

### Check Outputs
```bash
terraform output
```

### Destroy Resources (when no longer needed)
```bash
terraform destroy
```

## Verification Steps

After applying the configuration:

1. **Verify EC2 Instance**:
   - Check AWS Console → EC2 → Instances
   - Look for instance named `datacenter-ec2`

2. **Verify CloudWatch Alarm**:
   - Check AWS Console → CloudWatch → Alarms
   - Look for alarm named `datacenter-alarm`

3. **Verify Outputs**:
   ```bash
   terraform output KKE_instance_name
   terraform output KKE_alarm_name
   ```

## Important Notes

1. **AWS Region**: The configuration uses `us-east-1` by default. Update the provider block in `main.tf` if you need a different region.

2. **SNS Topic**: The SNS topic `datacenter-sns-topic` must exist before applying this configuration.

3. **Cost Considerations**:
   - EC2 t2.micro instance costs (check AWS pricing)
   - CloudWatch alarm monitoring costs
   - SNS notification costs (if applicable)

4. **Security**:
   - The EC2 instance uses default security groups
   - Consider adding specific security group rules for your application

5. **Monitoring**:
   - The alarm will trigger when CPU utilization exceeds 90% for 5 minutes
   - Notifications will be sent to the configured SNS topic
   - Consider creating additional alarms for memory, disk, or network metrics

## Troubleshooting

### Common Issues

1. **Provider Authentication Error**:
   ```bash
   Error: No valid credential sources found
   ```
   Solution: Ensure AWS credentials are properly configured with `aws configure`

2. **SNS Topic Not Found**:
   ```bash
   Error: SNS topic not found
   ```
   Solution: Create the SNS topic `datacenter-sns-topic` in AWS Console

3. **Terraform State Errors**:
   If you encounter state-related errors:
   ```bash
   terraform init -reconfigure
   terraform refresh
   ```

4. **Resource Creation Timeout**:
   Increase timeout values in resource definitions if needed

## Maintenance

### Updating Configuration
1. Modify the `.tf` files as needed
2. Run `terraform plan` to see changes
3. Apply with `terraform apply`

### State Management
- State file is stored locally by default
- Consider using remote state (S3 backend) for production

### Monitoring
- Check CloudWatch metrics regularly
- Review alarm history in CloudWatch console
- Monitor SNS topic for notifications

## Support

For issues with this Terraform configuration:
1. Check Terraform documentation
2. Review AWS service limits and quotas
3. Consult AWS CloudWatch and EC2 documentation
4. Check Terraform plan output for specific errors

## License

This Terraform configuration is provided as-is for educational and demonstration purposes.
