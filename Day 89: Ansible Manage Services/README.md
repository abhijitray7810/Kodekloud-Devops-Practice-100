# 📦 DevOps 365 Days — Day 96  
## Install & Configure vsftpd on Nautilus App Servers Using Ansible

This task focuses on managing package installation and service configuration using **Ansible** within the Nautilus infrastructure (Stratos DC).  
The objective is to automate the installation and activation of the **vsftpd** service on all application servers.

---

## 🚀 Task Summary

The Nautilus DevOps team received a requirement from the development team to set up **vsftpd** on all app servers.  
To achieve this using Ansible, the following steps were completed:

### ✔️ Requirements:
- Create an Ansible playbook under  
  `/home/thor/ansible/playbook.yml`
- Install **vsftpd** on all app servers
- Start & enable the **vsftpd** service
- Use the existing inventory located at:  
  `/home/thor/ansible/inventory`
- Ensure playbook runs using:  
```

ansible-playbook -i inventory playbook.yml

```

---

## 📁 Directory Structure

```

/home/thor/ansible/
├── inventory
└── playbook.yml

````

---

## 📝 playbook.yml

```yaml
---
- name: Install and configure vsftpd on all app servers
  hosts: all
  become: yes

  tasks:
    - name: Install vsftpd package
      package:
        name: vsftpd
        state: present

    - name: Start and enable vsftpd service
      service:
        name: vsftpd
        state: started
        enabled: yes
````

---

## ▶️ How to Run the Playbook

Navigate to the Ansible directory:

```bash
cd /home/thor/ansible
```

Run the playbook:

```bash
ansible-playbook -i inventory playbook.yml
```

No extra arguments are required — matches validation conditions.

---

## 🧪 Testing Notes

* stapp01 and stapp03 installed vsftpd successfully.
* stapp02 initially failed due to a temporary module/connection issue (common in lab environments).
* Re-running the playbook resolved the issue.

---

## 🎯 Outcome

* **vsftpd installed** on all app servers
* **Service started & enabled**
* **Automation completed successfully using Ansible**
* Fully aligned with Nautilus DevOps standards

---

## 🔗 Connect With Me

If you find this useful, feel free to check out more DevOps 365 tasks in my repository!
Let’s grow together 🚀

```
