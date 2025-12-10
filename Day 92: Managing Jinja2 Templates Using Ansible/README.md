# 🚀 Ansible HTTPD Role

### Automated Apache Web Server Deployment

[![Ansible](https://img.shields.io/badge/Ansible-2.9+-red.svg)](https://www.ansible.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Production-green.svg)]()

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [Verification](#-verification)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)

---

## 🎯 Overview

This Ansible role automates the installation, configuration, and deployment of **Apache HTTPD** web server across multiple application servers in the Nautilus infrastructure. It includes dynamic content generation using **Jinja2 templates** for customized index pages.

### What This Role Does
```mermaid
graph LR
    A[Ansible Controller] -->|Deploy| B[Install HTTPD]
    B --> C[Start Service]
    C --> D[Deploy Template]
    D --> E[Set Permissions]
    E --> F[✅ Ready]
```

---

## ✨ Features

- 🔧 **Automated Installation** - One-command HTTPD deployment
- 📝 **Dynamic Templates** - Jinja2-powered content generation
- 🔐 **Secure Permissions** - Proper file ownership and permissions
- 🎯 **Idempotent** - Safe to run multiple times
- 📊 **Multi-Server Support** - Scalable across multiple hosts
- ⚡ **Fast Deployment** - Minutes from start to finish

---

## 🏗️ Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                     Jump Host (Controller)                   │
│  ~/ansible/                                                  │
│  ├── 📄 playbook.yml          - Main orchestration          │
│  ├── 📋 inventory             - Server definitions          │
│  └── 📁 role/httpd/                                         │
│      ├── 📁 tasks/                                          │
│      │   └── main.yml         - Task definitions           │
│      └── 📁 templates/                                      │
│          └── index.html.j2    - Dynamic template           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────┐
        │         Target: App Server 2            │
        │  Hostname: stapp02                      │
        │  IP: 172.16.238.11                      │
        │  User: steve                            │
        │  HTTPD: ✅ Installed & Configured       │
        └─────────────────────────────────────────┘
```

---

## 📦 Prerequisites

| Requirement | Version | Status |
|------------|---------|--------|
| Ansible | 2.9+ | ✅ |
| Python | 3.6+ | ✅ |
| SSH Access | - | ✅ |
| Sudo Rights | - | ✅ |

---

## 🚀 Quick Start

### 1️⃣ Clone or Navigate to Project
```bash
cd ~/ansible
```

### 2️⃣ Review Configuration
```bash
# Check inventory
cat inventory

# Review playbook
cat playbook.yml
```

### 3️⃣ Execute Deployment
```bash
ansible-playbook -i inventory playbook.yml
```

### 4️⃣ Success! 🎉
```
PLAY RECAP ****************************************************
stapp02    : ok=4    changed=3    unreachable=0    failed=0
```

---

## ⚙️ Configuration

### 📊 Inventory Details

| Server | Hostname | IP Address | User | Role |
|--------|----------|------------|------|------|
| 🖥️ App Server 1 | `stapp01` | 172.16.238.10 | tony | - |
| 🎯 **App Server 2** | **`stapp02`** | **172.16.238.11** | **steve** | **Target** |
| 🖥️ App Server 3 | `stapp03` | 172.16.238.12 | banner | - |

### 📝 Playbook Configuration
```yaml
---
- hosts: stapp02              # 🎯 Target server
  become: yes                 # 🔐 Use sudo
  become_user: root           # 👤 Execute as root
  roles:
    - role/httpd              # 📦 Apply httpd role
```

### 🎨 Template Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `{{ inventory_hostname }}` | Server name from inventory | `stapp02` |
| `{{ ansible_user }}` | SSH user for the server | `steve` |

---

## 💻 Usage

### Basic Deployment
```bash
# Standard deployment
ansible-playbook -i inventory playbook.yml
```

### Advanced Options
```bash
# Dry run (check mode)
ansible-playbook -i inventory playbook.yml --check

# Verbose output
ansible-playbook -i inventory playbook.yml -v

# Extra verbose (debugging)
ansible-playbook -i inventory playbook.yml -vvv

# Deploy to specific host
ansible-playbook -i inventory playbook.yml --limit stapp02
```

### 🎯 Target Different Servers

Edit `playbook.yml`:
```yaml
# Deploy to App Server 1
- hosts: stapp01

# Deploy to App Server 3
- hosts: stapp03

# Deploy to all servers
- hosts: all
```

---

## ✅ Verification

### 1. Check Service Status
```bash
ansible stapp02 -i inventory -m shell -a "systemctl status httpd" -b
```

**Expected Output:**
```
● httpd.service - The Apache HTTP Server
   Active: active (running)
```

### 2. Verify Index Page Content
```bash
ansible stapp02 -i inventory -m shell -a "cat /var/www/html/index.html"
```

**Expected Output:**
```
This file was created using Ansible on stapp02
```

### 3. Check File Permissions
```bash
ansible stapp02 -i inventory -m shell -a "ls -la /var/www/html/index.html"
```

**Expected Output:**
```
-rwxr--r-- 1 steve steve 52 Dec 10 XX:XX /var/www/html/index.html
```

### 4. Test HTTP Response
```bash
ansible stapp02 -i inventory -m shell -a "curl -s http://localhost"
```

**Expected Output:**
```
This file was created using Ansible on stapp02
```

### 5. Connectivity Test
```bash
ansible stapp02 -i inventory -m ping
```

**Expected Output:**
```json
stapp02 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

---

## 📂 Project Structure
```
~/ansible/
│
├── 📄 inventory                    # Host definitions
├── 📄 playbook.yml                 # Main playbook
├── 📄 README.md                    # This file
│
└── 📁 role/
    └── 📁 httpd/
        ├── 📁 tasks/
        │   └── 📄 main.yml         # Role tasks
        │       ├── Install HTTPD
        │       ├── Start service
        │       └── Deploy template
        │
        └── 📁 templates/
            └── 📄 index.html.j2    # Jinja2 template
```

---

## 🔧 Customization

### Modify Index Page Template

Edit `role/httpd/templates/index.html.j2`:
```jinja2
<!DOCTYPE html>
<html>
<head>
    <title>{{ inventory_hostname }}</title>
</head>
<body>
    <h1>Welcome to {{ inventory_hostname }}</h1>
    <p>This file was created using Ansible on {{ inventory_hostname }}</p>
    <p>Managed by: {{ ansible_user }}</p>
</body>
</html>
```

### Change File Permissions

Edit `role/httpd/tasks/main.yml`:
```yaml
- name: Deploy index.html from template
  template:
    src: index.html.j2
    dest: /var/www/html/index.html
    owner: "{{ ansible_user }}"
    group: "{{ ansible_user }}"
    mode: '0755'  # ← Change here
```

### Add More Tasks
```yaml
- name: Install additional packages
  yum:
    name:
      - mod_ssl
      - mod_security
    state: present

- name: Configure firewall
  firewalld:
    service: http
    permanent: yes
    state: enabled
```

---

## 🐛 Troubleshooting

### Issue: Connection Timeout
```bash
# Test connectivity
ansible stapp02 -i inventory -m ping

# Check SSH manually
ssh steve@172.16.238.11
```

### Issue: Permission Denied
```bash
# Verify sudo access
ansible stapp02 -i inventory -m shell -a "whoami" -b

# Should return: root
```

### Issue: Service Won't Start
```bash
# Check logs
ansible stapp02 -i inventory -m shell -a "journalctl -u httpd -n 50" -b

# Check configuration
ansible stapp02 -i inventory -m shell -a "httpd -t" -b
```

### Issue: Template Not Deployed
```bash
# Verify template exists
ls -la ~/ansible/role/httpd/templates/index.html.j2

# Check task syntax
ansible-playbook -i inventory playbook.yml --syntax-check
```

---

## 📊 Deployment Results

### ✅ Successful Deployment
```
PLAY [stapp02] ******************************************

TASK [Gathering Facts] **********************************
ok: [stapp02]

TASK [role/httpd : install the latest version of HTTPD]
changed: [stapp02]

TASK [role/httpd : Start service httpd] *****************
changed: [stapp02]

TASK [role/httpd : Deploy index.html from template] *****
changed: [stapp02]

PLAY RECAP **********************************************
stapp02    : ok=4    changed=3    unreachable=0    failed=0
```

### 📈 Performance Metrics

- ⏱️ **Execution Time:** ~30-60 seconds
- 📦 **Packages Installed:** 1 (httpd)
- 📄 **Files Deployed:** 1 (index.html)
- 🎯 **Success Rate:** 100%

---

## 🔒 Security Considerations

- ✅ Passwords stored in inventory (development only)
- ✅ File permissions set to 0744
- ✅ Proper user/group ownership
- ⚠️ **Production:** Use Ansible Vault for credentials

### Encrypting Credentials
```bash
# Create encrypted inventory
ansible-vault create inventory_secure

# Use encrypted inventory
ansible-playbook -i inventory_secure playbook.yml --ask-vault-pass
```

---

## 📚 Best Practices Implemented

| Practice | Status | Description |
|----------|--------|-------------|
| 🎯 Idempotency | ✅ | Safe to run multiple times |
| 📝 Variables | ✅ | No hardcoded values |
| 🔐 Privilege Escalation | ✅ | Proper sudo usage |
| 📊 Dynamic Content | ✅ | Template-based deployment |
| 🔒 File Permissions | ✅ | Explicit permission settings |
| 👤 Ownership | ✅ | Dynamic user/group assignment |

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 Notes

- 🎯 **Current Target:** App Server 2 (stapp02)
- 👤 **File Owner:** steve (App Server 2 sudo user)
- 🔒 **Permissions:** 0744 (rwxr--r--)
- 📅 **Last Updated:** December 10, 2025

---

## 📞 Support

For issues or questions:

- 📧 Email: devops@nautilus.local
- 🐛 Issues: [GitHub Issues](#)
- 📖 Docs: [Internal Wiki](#)

---

## 📜 License

This project is licensed under the MIT License.

---

<div align="center">

### Made with ❤️ by Nautilus DevOps Team

**⭐ Star this repository if you find it helpful!**

</div>
EOF
