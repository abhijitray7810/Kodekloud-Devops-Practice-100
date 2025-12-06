# Ansible Playbook - App Server 1 File Creation

## Overview
This Ansible project creates an empty file on App Server 1 in the Stratos DC environment. The playbook is designed to run from the jump host and execute tasks on the remote application server.

## Project Structure
```
/home/thor/ansible/
├── inventory          # Ansible inventory file
├── playbook.yml      # Main playbook
└── README.md         # This file
```

## Prerequisites
- Ansible installed on the jump host
- Network connectivity to App Server 1 (stapp01)
- Valid SSH credentials for the target server

## Inventory Configuration

The `inventory` file defines App Server 1 with the following details:

- **Host Group:** `app_server_1`
- **Hostname:** `stapp01`
- **IP Address:** `172.16.238.10`
- **SSH User:** `tony`
- **SSH Password:** `Ir0nM@n`

## Playbook Details

### playbook.yml

The playbook performs the following:

1. **Target:** Runs on all hosts in the `app_server_1` group
2. **Task:** Creates an empty file at `/tmp/file.txt`
3. **Module Used:** `file` module with `state: touch`
4. **Permissions:** Sets file mode to `0644` (owner: rw, group: r, others: r)

## Usage

### Running the Playbook

Execute the playbook from the `/home/thor/ansible` directory:

```bash
cd /home/thor/ansible
ansible-playbook -i inventory playbook.yml
```

### Expected Output

```
PLAY [Create file on App Server 1] *******************************************

TASK [Create empty file /tmp/file.txt] ***************************************
changed: [stapp01]

PLAY RECAP *******************************************************************
stapp01                    : ok=1    changed=1    unreachable=0    failed=0
```

## Verification

To verify the file was created successfully, you can SSH into App Server 1:

```bash
ssh tony@172.16.238.10
ls -la /tmp/file.txt
```

Expected output:
```
-rw-r--r-- 1 tony tony 0 Dec  6 10:00 /tmp/file.txt
```

## Troubleshooting

### Connection Issues
If you encounter SSH connection problems:
- Verify network connectivity: `ping 172.16.238.10`
- Check SSH access manually: `ssh tony@172.16.238.10`
- Ensure credentials are correct

### Permission Denied
If the playbook fails with permission errors:
- Verify the user `tony` has write access to `/tmp`
- Check if SELinux or AppArmor policies are blocking file creation

### Playbook Syntax Errors
Validate the playbook syntax before running:
```bash
ansible-playbook --syntax-check -i inventory playbook.yml
```

## Additional Operations

### Dry Run (Check Mode)
To simulate the playbook without making changes:
```bash
ansible-playbook -i inventory playbook.yml --check
```

### Verbose Output
For detailed execution information:
```bash
ansible-playbook -i inventory playbook.yml -v    # Basic verbosity
ansible-playbook -i inventory playbook.yml -vv   # More verbosity
ansible-playbook -i inventory playbook.yml -vvv  # Debug level
```

## Notes

- The playbook disables fact gathering (`gather_facts: no`) for faster execution
- SSH host key checking is disabled in the inventory for convenience
- The file module with `state: touch` creates the file if it doesn't exist or updates the timestamp if it does

## Support

For issues or questions regarding this playbook, contact the Stratos DC operations team.
