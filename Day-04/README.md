# Nginx Load Balancer Setup on Nautilus Infrastructure

## Overview
This project demonstrates the configuration of an **Nginx-based Load Balancer (LBR)** on the Nautilus infrastructure in the Stratos Datacenter.  
The load balancer distributes HTTP traffic across multiple application servers (App Servers) to ensure **high availability**, scalability, and improved performance for the hosted website.

---

## Inventory Details

| Host Group | Hostname / IP           | User    | Password   | Role           |
|------------|------------------------|---------|-----------|----------------|
| LBR        | stlb01                  | loki    | Mischi3f  | Load Balancer  |
| App        | stapp01 (172.16.238.10)| tony    | Ir0nM@n   | App Server 1   |
| App        | stapp02 (172.16.238.11)| steve   | Am3ric@   | App Server 2   |
| App        | stapp03 (172.16.238.12)| banner  | BigGr33n  | App Server 3   |

---

## Prerequisites
- Jump host with **Ansible installed**.
- Password-based SSH access enabled for all hosts.
- Apache service running on all App Servers (default port `5001`).
- Nginx not installed on the LBR server.

---

## Setup Instructions

### 1. Install Ansible
```bash
sudo yum install -y epel-release
sudo yum install -y ansible
ansible --version
````

### 2. Create Project Directory

```bash
mkdir ~/ansible-project
cd ~/ansible-project
```

### 3. Create Inventory File

```bash
vi inventory.ini
```

Add the following content:

```ini
[lbr]
stlb01 ansible_user=loki ansible_ssh_pass=Mischi3f ansible_become_pass=Mischi3f ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[app]
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_ssh_pass=Ir0nM@n ansible_become_pass=Ir0nM@n
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_ssh_pass=Am3ric@ ansible_become_pass=Am3ric@ 
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_ssh_pass=BigGr33n ansible_become_pass=BigGr33n
```

### 4. Create Ansible Playbook

```bash
vi lbr_setup.yml
```

Paste the following playbook:

```yaml
---
- name: Configure Nginx as Load Balancer
  hosts: lbr
  become: yes

  tasks:
    - name: Install nginx
      package:
        name: nginx
        state: present

    - name: Configure nginx.conf for load balancing with App server IPs
      copy:
        dest: /etc/nginx/nginx.conf
        content: |
          user  nginx;
          worker_processes  auto;
          error_log  /var/log/nginx/error.log warn;
          pid        /var/run/nginx.pid;

          events {
              worker_connections  1024;
          }

          http {
              upstream app_servers {
                  server 172.16.238.10:5001;
                  server 172.16.238.11:5001;
                  server 172.16.238.12:5001;
              }

              server {
                  listen 80;

                  location / {
                      proxy_pass http://app_servers;
                      proxy_set_header Host $host;
                      proxy_set_header X-Real-IP $remote_addr;
                      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto $scheme;
                  }
              }
          }

    - name: Restart nginx
      service:
        name: nginx
        state: restarted
        enabled: yes
```

---

### 5. Run the Playbook

From the project directory:

```bash
ansible-playbook -i inventory.ini lbr_setup.yml
```

---

### 6. Verify Setup

1. Check HTTP response from LBR:

```bash
curl -I http://stlb01
```

Expected output:

```
HTTP/1.1 200 OK
Server: nginx/1.20.1
```

2. Use the **StaticApp** button in the Nautilus portal to access the website.

3. Optional: Verify round-robin load balancing:

```bash
for i in {1..10}; do curl http://stlb01; done
```

> Each request will be forwarded to different App Servers if the content differs.

---

## Notes

* Apache service must remain running on App Servers (`systemctl status httpd`) before enabling LBR.
* The playbook replaces the main `nginx.conf` on LBR and sets up upstream load balancing for HTTP traffic.

---

## Author

**xFusionCorp Industries – Nautilus DC Lab**

```

---


