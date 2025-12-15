# Create RSA key pair
resource "tls_private_key" "nautilus_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair using the generated RSA key
resource "aws_key_pair" "nautilus_kp" {
  key_name   = "nautilus-kp"
  public_key = tls_private_key.nautilus_key.public_key_openssh
}

# Save private key locally (optional but recommended)
resource "local_file" "private_key" {
  content         = tls_private_key.nautilus_key.private_key_pem
  filename        = "${path.module}/nautilus-kp.pem"
  file_permission = "0400"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get the default security group
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

# Create EC2 instance
resource "aws_instance" "nautilus_ec2" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.nautilus_kp.key_name

  vpc_security_group_ids = [data.aws_security_group.default.id]

  tags = {
    Name = "nautilus-ec2"
  }
}

# Output the instance details
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.nautilus_ec2.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.nautilus_ec2.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.nautilus_ec2.public_dns
}

output "private_key_path" {
  description = "Path to the private key file"
  value       = local_file.private_key.filename
}
