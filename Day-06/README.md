# WordPress Hosting Setup – xFusionCorp Industries

This project automates the setup of a WordPress-ready environment on **xFusionCorp’s Stratos Datacenter** using **Ansible**.  
It configures **App Servers** with Apache + PHP and a **DB Server** with MariaDB, ensuring connectivity through a shared storage directory.

---

## 🚀 Infrastructure Overview
- **App Servers**: `stapp01`, `stapp02`, `stapp03`
  - Apache (`httpd`) installed
  - PHP + MySQL extension installed
  - Apache configured to run on port **6100**
  - Shared storage mounted at `/var/www/html`
  - PHP test page confirms DB connectivity

- **DB Server**: `stdb01`
  - MariaDB installed and configured
  - Remote connections enabled
  - Database `kodekloud_db9` created
  - User `kodekloud_roy` with full privileges (`ALL`) on `kodekloud_db9`
  - Firewall allows MySQL connections

---

## 🛠 Requirements
- Control node (jump host) with:
  - **Ansible 2.9+**
  - **EPEL repository** enabled
- SSH access to all servers with proper credentials

---

## 📂 Project Structure
```

ansible/
├── inventory.ini     # Inventory file (defines app & db servers)
├── playbook.yaml     # Ansible playbook (configures servers)
└── README.md         # Documentation

````

---

## ⚙️ Inventory File (inventory.ini)
```ini
[app_servers]
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_ssh_pass=Ir0nM@n ansible_become_pass=Ir0nM@n
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_ssh_pass=Am3ric@ ansible_become_pass=Am3ric@
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_ssh_pass=BigGr33n ansible_become_pass=BigGr33n

[db_server]
stdb01 ansible_host=172.16.239.10 ansible_user=peter ansible_ssh_pass=Sp!dy ansible_become_pass=Sp!dy
````

---

## ▶️ Running the Playbook

```bash
# Run from jump host
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yaml
```

---

## ✅ Verification

1. Open the **LBR (Load Balancer) link** from Stratos DC.
2. Access the application at:

   ```
   http://<LBR_IP_or_hostname>:6100
   ```
3. You should see:

   ```
   App is able to connect to the database using user kodekloud_roy
   ```

---

## 📌 Next Steps

* Replace `/var/www/html/index.php` with **WordPress files**.
* Update `wp-config.php` with:

  * DB Name: `kodekloud_db9`
  * DB User: `kodekloud_roy`
  * DB Password: `LQfKeWWxWD`
  * DB Host: `172.16.239.10`

---

## 🤝 Author

Automation created for **xFusionCorp Industries** using **Ansible** in Stratos Datacenter.

```
