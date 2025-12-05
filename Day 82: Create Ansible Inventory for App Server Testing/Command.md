
# Ansible Inventory Setup for App Server 2

This document contains the commands required to create and configure the Ansible inventory file for testing playbooks on **App Server 2 (stapp02)** from the jump host.

---

## Step 1: Navigate to Playbook Directory

```bash
cd /home/thor/playbook/
````

---

## Step 2: Create the Inventory File

```bash
vi inventory
```

---

## Step 3: Add App Server 2 to the Inventory

Use the correct hostname as per the wiki: **stapp02**

```ini
[app_servers]
stapp02 ansible_host=<APP_SERVER_2_IP> ansible_user=<SSH_USER> ansible_password=<SSH_PASSWORD>
```

Replace the placeholders with actual values:

* `<APP_SERVER_2_IP>` → IP address of App Server 2
* `<SSH_USER>` → SSH username
* `<SSH_PASSWORD>` → SSH password

---

## Step 4: Verify Inventory File

```bash
cat inventory
```

---

## Step 5: Run the Playbook for Validation

```bash
ansible-playbook -i inventory playbook.yml
```

✅ This command should execute successfully without any extra arguments.

```

---

If you want, I can also generate this file directly using a shell `cat <<EOF` command for quick creation.
```
