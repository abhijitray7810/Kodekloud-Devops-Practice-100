# Ansible httpd Web Server Setup

This Ansible playbook automates the installation and configuration of httpd web servers across all app servers in the Stratos DC environment.

## Prerequisites

- Ansible installed on the jump host
- SSH access to all app servers
- Sudo privileges on target servers
- Inventory file present at `/home/thor/ansible/inventory`

## Directory Structure

```
/home/thor/ansible/
├── inventory
├── playbook.yml
└── README.md
```

## Playbook Overview

The `playbook.yml` performs the following tasks:

1. **Installs httpd package** on all app servers
2. **Starts and enables httpd service** to run on boot
3. **Creates `/var/www/html/index.html`** with sample content using blockinfile module
4. **Sets file ownership** to `apache:apache`
5. **Sets file permissions** to `0644`

## Usage

### Running the Playbook

From the `/home/thor/ansible` directory on the jump host, execute:

```bash
ansible-playbook -i inventory playbook.yml
```

### Expected Output

The playbook will execute tasks across all app servers with output similar to:

```
PLAY [Setup httpd web server on all app servers] *****************************

TASK [Gathering Facts] *******************************************************
ok: [app_server_1]
ok: [app_server_2]
ok: [app_server_3]

TASK [Install httpd package] *************************************************
changed: [app_server_1]
changed: [app_server_2]
changed: [app_server_3]

TASK [Start and enable httpd service] ****************************************
changed: [app_server_1]
changed: [app_server_2]
changed: [app_server_3]

TASK [Create index.html with content using blockinfile] **********************
changed: [app_server_1]
changed: [app_server_2]
changed: [app_server_3]

TASK [Set owner and group for index.html] ************************************
changed: [app_server_1]
changed: [app_server_2]
changed: [app_server_3]

PLAY RECAP *******************************************************************
app_server_1    : ok=5    changed=4    unreachable=0    failed=0
app_server_2    : ok=5    changed=4    unreachable=0    failed=0
app_server_3    : ok=5    changed=4    unreachable=0    failed=0
```

## Verification

After running the playbook, verify the setup:

### Check httpd Service Status

```bash
ansible all -i inventory -m shell -a "systemctl status httpd" --become
```

### View index.html Content

```bash
ansible all -i inventory -m shell -a "cat /var/www/html/index.html" --become
```

### Check File Permissions

```bash
ansible all -i inventory -m shell -a "ls -l /var/www/html/index.html" --become
```

Expected output:
```
-rw-r--r--. 1 apache apache <size> <date> /var/www/html/index.html
```

### Test Web Server Response

```bash
ansible all -i inventory -m shell -a "curl http://localhost" --become
```

## Web Page Content

The deployed `index.html` file contains:

```
# BEGIN ANSIBLE MANAGED BLOCK
Welcome to XfusionCorp!
This is Nautilus sample file, created using Ansible!
Please do not modify this file manually!
# END ANSIBLE MANAGED BLOCK
```

**Note:** The `# BEGIN ANSIBLE MANAGED BLOCK` and `# END ANSIBLE MANAGED BLOCK` markers are automatically added by the `blockinfile` module.

## File Specifications

| Property | Value |
|----------|-------|
| File Path | `/var/www/html/index.html` |
| Owner | `apache` |
| Group | `apache` |
| Permissions | `0644` (rw-r--r--) |

## Playbook Features

- **Idempotent**: Safe to run multiple times
- **No manual intervention required**: Fully automated
- **Uses become (sudo)**: Elevated privileges for package installation and service management
- **Cross-platform**: Uses generic `package` module for compatibility

## Troubleshooting

### Playbook Fails to Connect

- Verify SSH connectivity: `ansible all -i inventory -m ping`
- Check inventory file format and host definitions

### httpd Service Won't Start

- Check SELinux status: `getenforce`
- Review httpd error logs: `journalctl -u httpd -n 50`

### Permission Denied Errors

- Ensure `become: yes` is set in playbook
- Verify sudo access on target servers

### Port 80 Already in Use

- Check for conflicting services: `netstat -tulpn | grep :80`
- Stop conflicting services before running playbook

## Notes

- The playbook targets all hosts defined in the inventory file
- Default blockinfile markers are used (not custom or empty)
- The playbook is designed to work with the command: `ansible-playbook -i inventory playbook.yml`
- No additional arguments or flags are required

## Author

Created for the Nautilus DevOps team - Stratos DC Infrastructure
