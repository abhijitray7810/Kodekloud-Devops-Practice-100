# Ansible Inventory Configuration Guide

## Overview
This document provides instructions for creating and configuring the Ansible inventory file for the Nautilus DevOps team's playbook testing on Stratos DC servers.

## Requirements
- **Location**: `/home/thor/playbook/inventory`
- **Format**: INI
- **Target**: App Server 2 in Stratos DC
- **Hostname Convention**: `stapp02` (as per Stratos DC wiki)

## Inventory File Structure

### Basic Configuration
```ini
[app_servers]
stapp02 ansible_host=<app_server_2_ip> ansible_user=<username> ansible_ssh_pass=<password> ansible_connection=ssh
```

### Configuration with Sudo Access
If your playbook requires elevated privileges:
```ini
[app_servers]
stapp02 ansible_host=<app_server_2_ip> ansible_user=<username> ansible_ssh_pass=<password> ansible_connection=ssh ansible_become=yes ansible_become_pass=<sudo_password>
```

### Configuration with SSH Key Authentication
For key-based authentication (more secure):
```ini
[app_servers]
stapp02 ansible_host=<app_server_2_ip> ansible_user=<username> ansible_ssh_private_key_file=/home/thor/.ssh/id_rsa ansible_connection=ssh
```

## Variables Explained

| Variable | Description | Example |
|----------|-------------|---------|
| `stapp02` | Inventory hostname for App Server 2 | `stapp02` |
| `ansible_host` | IP address or FQDN of the server | `172.16.238.11` |
| `ansible_user` | SSH username | `steve`, `tony`, or `banner` |
| `ansible_ssh_pass` | SSH password for the user | `password123` |
| `ansible_connection` | Connection type | `ssh` |
| `ansible_become` | Enable privilege escalation | `yes` or `no` |
| `ansible_become_pass` | Sudo password | `password123` |
| `ansible_ssh_private_key_file` | Path to SSH private key | `/home/thor/.ssh/id_rsa` |

## Stratos DC Server Naming Convention

| Server | Inventory Hostname |
|--------|-------------------|
| App Server 1 | `stapp01` |
| App Server 2 | `stapp02` |
| App Server 3 | `stapp03` |

## Step-by-Step Setup

### 1. Create the Inventory File
```bash
cd /home/thor/playbook/
nano inventory
```

### 2. Add Server Configuration
Replace placeholders with actual values from your Stratos DC wiki:
- `<app_server_2_ip>`: Server IP address
- `<username>`: SSH username
- `<password>`: User password

### 3. Verify Connectivity
Test the connection to App Server 2:
```bash
ansible -i inventory stapp02 -m ping
```

Expected output:
```
stapp02 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### 4. Run Your Playbook
```bash
ansible-playbook -i inventory playbook.yml
```

## Common Stratos DC Credentials

Based on typical Stratos DC configurations (verify with your wiki):

**App Server 2 (stapp02)**:
- **Username**: `steve` (or `tony`/`banner`)
- **IP**: Check wiki for current IP
- **Port**: 22 (default SSH)

## Troubleshooting

### Connection Timeout
```bash
# Add custom SSH port if needed
stapp02 ansible_host=<ip> ansible_port=2222 ansible_user=<username>
```

### Host Key Verification Failed
```bash
# Disable strict host key checking (development only)
stapp02 ansible_host=<ip> ansible_user=<username> ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

### Permission Denied
- Verify username and password
- Check if user has SSH access
- Ensure correct privileges for playbook tasks

## Security Best Practices

### 1. Use Ansible Vault for Sensitive Data
```bash
# Create encrypted variables file
ansible-vault create vars/secrets.yml

# Add passwords to secrets.yml
ansible_ssh_pass: "your_password"
ansible_become_pass: "your_sudo_password"

# Update inventory to use variables
[app_servers]
stapp02 ansible_host=<ip> ansible_user=<username>
```

### 2. Use SSH Keys Instead of Passwords
```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096

# Copy public key to App Server 2
ssh-copy-id <username>@<app_server_2_ip>

# Update inventory
stapp02 ansible_host=<ip> ansible_user=<username> ansible_ssh_private_key_file=/home/thor/.ssh/id_rsa
```

### 3. Limit Inventory Permissions
```bash
chmod 600 /home/thor/playbook/inventory
```

## Example Complete Inventory

```ini
# Stratos DC - App Servers Inventory
# Created: 2025-12-05
# Purpose: Ansible playbook testing

[app_servers]
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_ssh_pass=Ir0nM@n ansible_connection=ssh ansible_become=yes ansible_become_pass=Ir0nM@n

[app_servers:vars]
ansible_python_interpreter=/usr/bin/python3
```

## Additional Resources

- [Ansible Inventory Documentation](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)
- [Ansible Connection Variables](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#connecting-to-hosts-behavioral-inventory-parameters)
- [Ansible Vault Guide](https://docs.ansible.com/ansible/latest/vault_guide/index.html)

## Notes

- Always verify credentials from the official Stratos DC wiki before deployment
- The validation command `ansible-playbook -i inventory playbook.yml` must work without additional arguments
- Ensure the inventory file is located exactly at `/home/thor/playbook/inventory`
- Test connectivity before running production playbooks

---

**Last Updated**: December 2025  
**Maintained By**: Nautilus DevOps Team
