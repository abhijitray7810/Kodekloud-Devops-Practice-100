# Jenkins Pipeline Deployment Guide for xFusionCorp Industries

## Overview
This guide provides step-by-step instructions for setting up a Jenkins pipeline to deploy a static website from Gitea to Nautilus App Servers using a Storage Server as an intermediary deployment node.

## Architecture
- **Source Control**: Gitea repository (`web_app` under user `sarah`)
- **CI/CD**: Jenkins with pipeline job
- **Deployment Target**: Storage Server (`/var/www/html`)
- **Application Servers**: Multiple app servers with Apache running on port 8080
- **Load Balancer**: Distributes traffic to app servers

## Prerequisites
- Jenkins access: `admin` / `Adm!n321`
- Gitea access: `sarah` / `Sarah_pass123`
- Storage Server with SSH access
- Apache installed on all app servers (port 8080)
- Repository `web_app` already cloned at `/var/www/html/web_app` on Storage Server

---

## Step 1: Install Required Jenkins Plugins

### 1.1 Navigate to Plugin Manager
1. Login to Jenkins UI
2. Go to **Manage Jenkins** → **Manage Plugins**
3. Click on **Available** tab

### 1.2 Install Required Plugins
Search and install the following plugins:
- **SSH Build Agents Plugin** - For slave node connectivity
- **Git Plugin** - For Git repository integration
- **Pipeline Plugin** - For pipeline functionality (usually pre-installed)
- **Gitea Plugin** (Optional) - For enhanced Gitea integration

### 1.3 Restart Jenkins
- Check the box: **"Restart Jenkins when installation is complete and no jobs are running"**
- Wait for Jenkins to restart (refresh the page if UI gets stuck)

---

## Step 2: Configure Storage Server as Jenkins Slave Node

### 2.1 Add SSH Credentials
1. Go to **Manage Jenkins** → **Manage Credentials**
2. Click on **(global)** domain
3. Click **Add Credentials**
4. Configure:
   - **Kind**: SSH Username with private key
   - **ID**: `storage-server-ssh`
   - **Description**: Storage Server SSH Access
   - **Username**: (SSH username for Storage Server, e.g., `root` or appropriate user)
   - **Private Key**: Enter directly or from file
   - Click **Create**

### 2.2 Create New Node
1. Go to **Manage Jenkins** → **Manage Nodes and Clouds**
2. Click **New Node**
3. Configure:
   - **Node name**: `Storage Server`
   - Select: **Permanent Agent**
   - Click **Create**

###
