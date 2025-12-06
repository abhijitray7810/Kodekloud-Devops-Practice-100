# Ansible File Copy - Stratos DC Application Servers

This repository contains Ansible configuration to copy files from the jump host to all application servers in the Stratos Data Center.

## Overview

The setup includes an inventory file and a playbook that copies `/usr/src/devops/index.html` from the jump host to `/opt/devops/index.html` on all application servers.

## Directory Structure

```
/home/thor/ansible/
├── inventory          # Ansible inventory file
├── playbook.yml       # Ansible playbook
└── README.md          # This file
```

## Infrastructure

### Application Servers

| Server  | Hostname | IP Address      | User   | Password  |
|---------|----------|-----------------|--------|-----------|
| stapp01 | stapp01  | 172.16.238.10   | tony   | Ir0nM@n   |
| stapp02 | stapp02  | 172.16.238.11   | steve  | Am3ric@   |
| stapp03 | stapp03  | 172.16.238.12   | banner | BigGr33n  |

## Prerequisites

- Ansible installed on jump host
- SSH access to all application servers
- Source file exists at `/usr/src/devops/index.html` on jump host
- Sudo privileges on application servers

## Installation

1. Create the ansible directory:
```bash
mkdir -p /home/thor/ansible
cd /home/thor/ansible
```

2. Create the inventory file at `/home/thor/ansible/inventory`

3. Create the playbook at `/home/thor/ansible/playbook.yml`

## Usage

### Running the Playbook

Execute the playbook from the `/home/thor/ansible` directory:

```bash
ansible-playbook -i inventory playbook.yml
```

### Expected Output

```
PLAY [Copy index.html file to all application servers] ************************

TASK [Ensure destination directory exists] ************************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

TASK [Copy index.html from jump host to application servers] ******************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

PLAY RECAP *********************************************************************
stapp01 : ok=2    changed=2    unreachable=0    failed=0    skipped=0
stapp02 : ok=2    changed=2    unreachable=0    failed=0    skipped=0
stapp03 : ok=2    changed=2    unreachable=0    failed=0    skipped=0
```

## What the Playbook Does

1. **Creates destination directory**: Ensures `/opt/devops` exists on all application servers with proper permissions (755)

2. **Copies the file**: Transfers `/usr/src/devops/index.html` from jump host to `/opt/devops/index.html` on each application server with permissions (644)

## Verification

After running the playbook, verify the file was copied successfully:

```bash
# Check from jump host using ansible ad-hoc command
ansible -i inventory app_servers -m shell -a "ls -la /opt/devops/index.html" --become

# Or SSH to individual servers
ssh tony@172.16.238.10 "sudo ls -la /opt/devops/index.html"
ssh steve@172.16.238.11 "sudo ls -la /opt/devops/index.html"
ssh banner@172.16.238.12 "sudo ls -la /opt/devops/index.html"
```

## Troubleshooting

### Connection Issues

If you encounter SSH connection issues:

```bash
# Test connectivity
ansible -i inventory app_servers -m ping

# Check SSH connectivity manually
ssh -o StrictHostKeyChecking=no tony@172.16.238.10
```

### Permission Denied

If you get permission errors:
- Verify the user credentials in the inventory file
- Ensure the users have sudo privileges on the application servers
- Check that `become: yes` is present in the playbook

### Source File Not Found

If the source file doesn't exist:

```bash
# Verify the source file exists on jump host
ls -la /usr/src/devops/index.html

# Create a test file if needed
sudo mkdir -p /usr/src/devops
echo "Test content" | sudo tee /usr/src/devops/index.html
```

## Configuration Details

### Inventory Configuration

- **Host Group**: `app_servers` contains all three application servers
- **Connection**: SSH with password authentication
- **StrictHostKeyChecking**: Disabled for automated execution
- **Python Interpreter**: Set to `/usr/bin/python3`

### Playbook Configuration

- **Target**: All hosts in `app_servers` group
- **Privilege Escalation**: Uses sudo (`become: yes`)
- **Gather Facts**: Disabled for faster execution
- **Idempotent**: Can be run multiple times safely

## Security Notes

⚠️ **Warning**: This configuration contains plaintext passwords in the inventory file. In production environments:

- Use Ansible Vault to encrypt sensitive data
- Implement SSH key-based authentication
- Use privilege escalation passwords separately
- Restrict inventory file permissions: `chmod 600 inventory`

## Additional Commands

### Check Ansible Version
```bash
ansible --version
```

### Test Inventory
```bash
ansible-inventory -i inventory --list
```

### Dry Run (Check Mode)
```bash
ansible-playbook -i inventory playbook.yml --check
```

### Verbose Output
```bash
ansible-playbook -i inventory playbook.yml -v
# or for more verbosity: -vv, -vvv, -vvvv
```

## Support

For issues or questions related to the Stratos DC DevOps environment, contact the Nautilus DevOps team.

## License

Internal use only - Nautilus DevOps Team
