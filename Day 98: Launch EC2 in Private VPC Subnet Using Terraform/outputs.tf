output "KKE_vpc_name" {
  description = "Name of the VPC"
  value       = aws_vpc.datacenter_priv_vpc.tags["Name"]
}

output "KKE_subnet_name" {
  description = "Name of the subnet"
  value       = aws_subnet.datacenter_priv_subnet.tags["Name"]
}

output "KKE_ec2_private" {
  description = "Name of the EC2 instance"
  value       = aws_instance.datacenter_priv_ec2.tags["Name"]
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.datacenter_priv_vpc.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = aws_subnet.datacenter_priv_subnet.id
}

output "ec2_instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.datacenter_priv_ec2.id
}

output "ec2_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.datacenter_priv_ec2.private_ip
}
