# Nautilus DevOps - httpd Web Server Setup

## Overview
This project contains an Ansible playbook to automate the installation and configuration of httpd web servers across all app servers in the Stratos Data Center. The playbook deploys a sample web page with specific content, ownership, and permissions.

## Project Structure
```
/home/thor/ansible/
├── inventory          # Inventory file with app server details
├── playbook.yml       # Main Ansible playbook
└── README.md          # This documentation file
```

## Prerequisites
- Ansible installed on the jump host
- SSH access to all app servers (stapp01, stapp02, stapp03)
- Sudo privileges on target servers
- Inventory file configured with app server details

## Playbook Features

### Tasks Performed
1. **Install httpd Package** - Installs the Apache HTTP server on all app servers
2. **Start and Enable Service** - Ensures httpd is running and starts automatically on boot
3. **Create index.html** - Creates the web page with initial content
4. **Add Welcome Message** - Inserts additional content at the top of the file
5. **Set Permissions** - Configures proper ownership and file permissions

### Configuration Details
- **Web Root**: `/var/www/html/`
- **Index File**: `/var/www/html/index.html`
- **File Owner**: `apache`
- **File Group**: `apache`
- **Permissions**: `0744` (rwxr--r--)

### Web Page Content
```
Welcome to xFusionCorp Industries!
This is a Nautilus sample file, created using Ansible!
```

## Usage

### Running the Playbook
Execute the playbook from the jump host:
```bash
cd /home/thor/ansible
ansible-playbook -i inventory playbook.yml
```

### Verification
Check the playbook execution results:
```bash
# Verify httpd is running on app servers
ansible -i inventory all -m shell -a "systemctl status httpd"

# Check the web page content
ansible -i inventory all -m shell -a "cat /var/www/html/index.html"

# Verify file permissions
ansible -i inventory all -m shell -a "ls -l /var/www/html/index.html"

# Test web page via curl (replace with actual app server IPs)
curl http://<app-server-ip>/
```

## Playbook Execution Output
```
PLAY RECAP
stapp01: ok=6  changed=4  unreachable=0  failed=0
stapp02: ok=6  changed=4  unreachable=0  failed=0
stapp03: ok=6  changed=4  unreachable=0  failed=0
```

## Technical Details

### Ansible Modules Used
- **package**: Cross-platform package installation
- **service**: Service management (start, stop, enable)
- **copy**: File creation with content
- **lineinfile**: Line-by-line file manipulation
- **file**: File attributes management

### Idempotency
The playbook is idempotent, meaning:
- Running it multiple times produces the same result
- No changes occur if the desired state is already achieved
- Safe to run repeatedly without side effects

## Troubleshooting

### Common Issues

**Issue**: Playbook fails with permission errors
- **Solution**: Ensure `become: yes` is set and SSH user has sudo privileges

**Issue**: httpd service fails to start
- **Solution**: Check if port 80 is already in use: `netstat -tuln | grep :80`

**Issue**: Cannot access web page
- **Solution**: Verify firewall settings allow HTTP traffic:
  ```bash
  firewall-cmd --list-all
  firewall-cmd --permanent --add-service=http
  firewall-cmd --reload
  ```

**Issue**: File ownership incorrect
- **Solution**: Verify apache user exists: `id apache`

## Maintenance

### Updating Web Content
To update the web page content, modify the playbook and re-run:
```bash
ansible-playbook -i inventory playbook.yml
```

### Removing httpd
To uninstall httpd from all servers:
```bash
ansible -i inventory all -b -m package -a "name=httpd state=absent"
```

## Security Considerations
- File permissions `0744` allow owner (apache) full control
- Group and others have read-only access
- httpd runs under the apache user for security isolation
- Regular security updates recommended

## Author
Nautilus DevOps Team - xFusionCorp Industries

## Last Updated
December 2025

## Support
For issues or questions, contact the Nautilus DevOps team.

---
**Note**: This playbook is designed to work without additional arguments for validation purposes.
