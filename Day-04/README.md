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
