# 📘 Ansible Playbook – Install Zip Package on App Servers

This project automates the installation of the **zip** package on all application servers in the Stratos Datacenter using **Ansible**.

---

## 📁 Project Structure

```
/home/thor/playbook/
│
├── inventory
└── playbook.yml
```

---

## 🧾 Inventory File (`inventory`)

The inventory contains all three application servers under the **app_servers** group:

```
[app_servers]
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_ssh_pass=Ir0nM@n
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_ssh_pass=Am3ric@
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_ssh_pass=BigGr33n
```

---

## ▶️ Playbook (`playbook.yml`)

The playbook installs the **zip** package on all app servers using the **yum** module:

```yaml
---
- name: Install zip package on all app servers
  hosts: app_servers

  tasks:
    - name: Install zip package using yum
      yum:
        name: zip
        state: present
```

---

## 🚀 Running the Playbook

Navigate to the project directory:

```bash
cd /home/thor/playbook
```

Execute the playbook:

```bash
ansible-playbook -i inventory playbook.yml
```

---

## ✅ Expected Output

Successful execution should show:

```
TASK [Install zip package using yum]
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]
```

---

## 🔧 Notes

* This setup does **not** use `become: yes` because the provided remote users already have permission to run `yum`.
* Validation will run automatically using:

```
ansible-playbook -i inventory playbook.yml
```

