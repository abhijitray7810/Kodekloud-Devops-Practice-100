# Nautilus App Deployment Automation with Jenkins

## 📋 Project Overview

This document outlines the complete setup for automating the deployment of the Nautilus web application using Jenkins CI/CD pipeline integrated with Gitea version control.

---

## 🏗️ Architecture

```
Developer Push → Gitea Repository → Jenkins Webhook Trigger → Auto Deploy → Storage Server → App Servers (via NFS)
```

### Components:
- **Jenkins Server**: CI/CD automation platform
- **Gitea**: Git repository hosting service
- **Storage Server**: Centralized NFS storage server
- **App Servers (3x)**: Apache httpd web servers on port 8080
- **Load Balancer**: Traffic distribution to app servers

---

## 🔐 Access Credentials

| Service | Username | Password | Access |
|---------|----------|----------|--------|
| Jenkins | admin | Adm!n321 | Jenkins UI button |
| Gitea | sarah | Sarah_pass123 | Gitea UI button |
| SSH (Storage) | sarah | Sarah_pass123 | Terminal/SSH |

---

## 📝 Requirements

### 1. Apache Installation
- Install `httpd` on all app servers
- Configure to serve on port **8080**
- Document root: `/var/www/html`

### 2. Jenkins Job Configuration
- **Job Name**: `nautilus-app-deployment`
- **Trigger**: Auto-build on push to `master` branch
- **Deploy Location**: `/var/www/html` on Storage Server
- **Ownership**: Directory owned by user `sarah`

### 3. Content Deployment
- Update `index.html` with: `Welcome to the xFusionCorp Industries`
- Push triggers automatic deployment
- Deploy entire repository content (not just index.html)

---

## 🚀 Implementation Guide

### Phase 1: Apache Setup on App Servers

#### Option A: Manual Installation (All App Servers)

```bash
# SSH to each app server (stapp01, stapp02, stapp03)
# Use respective credentials

# Install Apache
sudo yum install httpd -y

# Configure Apache to listen on port 8080
sudo sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Verify Apache is running
sudo systemctl status httpd
curl http://localhost:8080
```

#### Option B: Jenkins Job Integration
Include Apache installation in the Jenkins pipeline for automated setup.

---

### Phase 2: Storage Server Preparation

```bash
# SSH to Storage Server as sarah
ssh sarah@ststor01
# Password: Sarah_pass123

# Set ownership of web root to sarah
sudo chown -R sarah:sarah /var/www/html

# Verify the web repository exists
cd ~/web
ls -la

# Check git configuration
git status
git remote -v
```

---

### Phase 3: Jenkins Configuration

#### 3.1 Install Required Plugins

1. Navigate to **Manage Jenkins** → **Manage Plugins**
2. Go to **Available** tab
3. Install the following plugins:
   - **Git Plugin**
   - **Gitea Plugin** (for webhook integration)
   - **Publish Over SSH** (for deployment)
   - **Post Build Task Plugin** (optional)

4. Check: ✅ **Restart Jenkins when installation is complete and no jobs are running**
5. Wait for Jenkins to restart (refresh browser if UI hangs)

---

#### 3.2 Configure SSH Credentials for Storage Server

1. Go to **Manage Jenkins** → **Manage Credentials**
2. Click on **(global)** domain
3. Click **Add Credentials**
4. Configure:
   - **Kind**: Username with password
   - **Scope**: Global
   - **Username**: `sarah`
   - **Password**: `Sarah_pass123`
   - **ID**: `sarah-storage-ssh`
   - **Description**: `Sarah SSH credentials for Storage Server`
5. Click **Create**

---

#### 3.3 Configure SSH Server Connection

1. Go to **Manage Jenkins** → **Configure System**
2. Scroll to **Publish over SSH** section
3. Click **Add** under SSH Servers:
   - **Name**: `storage-server`
   - **Hostname**: `ststor01` (or IP address)
   - **Username**: `sarah`
   - **Remote Directory**: `/var/www/html`
4. Click **Advanced**
   - Check **Use password authentication**
   - **Password**: `Sarah_pass123`
5. Click **Test Configuration** (should show success)
6. Click **Save**

---

#### 3.4 Create Jenkins Job

1. From Jenkins Dashboard, click **New Item**
2. Enter name: `nautilus-app-deployment`
3. Select **Freestyle project**
4. Click **OK**

##### General Configuration:
- **Description**: `Auto-deploy web application from Gitea to Storage Server`
- ✅ Check **GitHub project** (or skip if not applicable)

##### Source Code Management:
- Select **Git**
- **Repository URL**: `http://<gitea-server>/sarah/web.git`
  - Example: `http://172.16.238.15:3000/sarah/web.git`
- **Credentials**: Add new credentials
  - **Kind**: Username with password
  - **Username**: `sarah`
  - **Password**: `Sarah_pass123`
  - **ID**: `gitea-sarah`
- **Branch Specifier**: `*/master`

##### Build Triggers:
- ✅ Check **Poll SCM**
  - **Schedule**: `* * * * *` (polls every minute)
  
**OR** (Recommended)

- ✅ Check **Gitea webhook** (if Gitea plugin installed)

##### Build Environment:
- ✅ Check **Delete workspace before build starts** (optional, for clean builds)

##### Build Steps:

**Add Build Step** → **Execute shell**

```bash
#!/bin/bash
# Display build information
echo "========================================="
echo "Starting Deployment Process"
echo "========================================="
echo "Build Number: ${BUILD_NUMBER}"
echo "Workspace: ${WORKSPACE}"
echo "========================================="

# List files to be deployed
echo "Files to be deployed:"
ls -la

# Ensure all files are readable
chmod -R 755 .
```

##### Post-build Actions:

**Add post-build action** → **Send build artifacts over SSH**

- **SSH Server**: Select `storage-server`
- **Transfers**:
  - **Source files**: `**/*` (deploy all files)
  - **Remove prefix**: (leave empty)
  - **Remote directory**: (leave empty - uses /var/www/html)
  - **Exec command**:
    ```bash
    sudo chown -R sarah:sarah /var/www/html
    sudo chmod -R 755 /var/www/html
    echo "Deployment completed successfully"
    ```

**Add post-build action** → **Post build task** (if plugin installed)
- **Log text**: `.*` (match any)
- **Script**:
  ```bash
  echo "Deployment to Storage Server completed at $(date)"
  ```

8. Click **Save**

---

#### 3.5 Setup Gitea Webhook (Optional but Recommended)

1. Login to Gitea UI as `sarah`
2. Navigate to the **web** repository
3. Go to **Settings** → **Webhooks**
4. Click **Add Webhook** → **Gitea**
5. Configure:
   - **Target URL**: `http://<jenkins-server>:8080/gitea-webhook/post`
   - **HTTP Method**: `POST`
   - **POST Content Type**: `application/json`
   - **Secret**: (leave empty or set matching Jenkins)
   - **Trigger On**: ✅ Push events
   - **Branch filter**: `master`
   - ✅ Active
6. Click **Add Webhook**
7. Click **Test Delivery** to verify

---

### Phase 4: Code Update and Deployment

```bash
# SSH to Storage Server as sarah
ssh sarah@ststor01

# Navigate to the web repository
cd ~/web

# Check current content
cat index.html

# Update index.html with required content
echo "Welcome to the xFusionCorp Industries" > index.html

# Verify the change
cat index.html

# Stage and commit changes
git add index.html
git commit -m "Update welcome message for xFusionCorp Industries"

# Push to master branch (triggers Jenkins job)
git push origin master
```

**Expected Output:**
```
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Writing objects: 100% (3/3), 290 bytes | 290.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To http://<gitea-server>/sarah/web.git
   abc1234..def5678  master -> master
```

---

### Phase 5: Verification

#### 5.1 Verify Jenkins Build

1. Go to Jenkins Dashboard
2. Click on `nautilus-app-deployment` job
3. Verify build is triggered automatically
4. Click on the latest build number
5. Click **Console Output** to view logs
6. Verify successful deployment messages

**Expected Console Output:**
```
Started by Gitea push notification
...
Checking out Revision abc123... (refs/remotes/origin/master)
...
SSH: Transferred 3 file(s)
SSH: Executing command: sudo chown -R sarah:sarah /var/www/html...
Deployment completed successfully
Finished: SUCCESS
```

#### 5.2 Verify Deployment on Storage Server

```bash
# SSH to Storage Server
ssh sarah@ststor01

# Check deployed files
ls -la /var/www/html/

# Verify content
cat /var/www/html/index.html
# Should show: Welcome to the xFusionCorp Industries

# Check ownership
ls -l /var/www/html/
# Should show: sarah sarah
```

#### 5.3 Verify Web Access

1. Click **App** button in the top bar
2. Verify URL shows: `https://<LBR-URL>`
3. Expected content: `Welcome to the xFusionCorp Industries`
4. Ensure no subdirectory in URL (no `/web` suffix)

**OR** using curl:

```bash
# From any server
curl http://<app-server>:8080
# Should return: Welcome to the xFusionCorp Industries
```

---

## 🔄 Testing Repetitive Runs

To ensure the Jenkins job is idempotent:

```bash
# Make another change
cd ~/web
echo "Welcome to the xFusionCorp Industries - Updated" > index.html
git add index.html
git commit -m "Test repetitive deployment"
git push origin master

# Build should trigger again and succeed
```

Verify:
- Jenkins job completes successfully
- No permission errors
- Content updates correctly

---

## 🐛 Troubleshooting

### Issue: Jenkins Not Triggering on Push

**Solution:**
- Verify webhook in Gitea is active and URL is correct
- Check Jenkins Poll SCM is configured
- Review Jenkins system log: **Manage Jenkins** → **System Log**

### Issue: Permission Denied on Deployment

**Solution:**
```bash
# On Storage Server
sudo chown -R sarah:sarah /var/www/html
sudo chmod -R 755 /var/www/html

# Ensure sarah has sudo privileges
sudo visudo
# Add: sarah ALL=(ALL) NOPASSWD: ALL
```

### Issue: Jenkins UI Stuck After Plugin Installation

**Solution:**
- Wait 2-3 minutes for restart
- Force refresh browser (Ctrl+F5)
- Clear browser cache
- Access Jenkins URL directly: `http://<jenkins-server>:8080`

### Issue: SSH Connection Failed

**Solution:**
```bash
# Test SSH manually
ssh sarah@ststor01

# Verify SSH service running
sudo systemctl status sshd

# Check Jenkins credentials are correct
```

### Issue: Wrong Content or Subdirectory in URL

**Solution:**
- Ensure Apache DocumentRoot is `/var/www/html`
- Verify deployment removes old files
- Check NFS mount on app servers:
  ```bash
  df -h | grep /var/www/html
  mount | grep /var/www/html
  ```

---

## 📸 Documentation

For validation purposes, capture:

1. **Jenkins Job Configuration Screenshots**:
   - Source Code Management settings
   - Build Triggers configuration
   - Post-build Actions (SSH transfer)

2. **Successful Build Console Output**

3. **Gitea Webhook Configuration**

4. **Final Web Application Screenshot** showing:
   - URL: `https://<LBR-URL>`
   - Content: `Welcome to the xFusionCorp Industries`

**Screen Recording Tool**: [Loom.com](https://loom.com)

---

## ✅ Validation Checklist

- [ ] Apache httpd installed on all app servers (stapp01, stapp02, stapp03)
- [ ] Apache configured to listen on port 8080
- [ ] `/var/www/html` owned by user sarah
- [ ] Jenkins job `nautilus-app-deployment` created
- [ ] Git repository configured in Jenkins
- [ ] Auto-trigger on push enabled (webhook or polling)
- [ ] SSH credentials configured for deployment
- [ ] index.html updated with required content
- [ ] Changes pushed to master branch
- [ ] Jenkins job triggered automatically
- [ ] Deployment successful (check console output)
- [ ] Content visible at `https://<LBR-URL>`
- [ ] No subdirectory in URL path
- [ ] Repetitive builds pass successfully

---

## 🔧 Jenkins Job Summary

```yaml
Job Name: nautilus-app-deployment
Type: Freestyle Project
SCM: Git
Repository: http://<gitea-server>/sarah/web.git
Branch: master
Trigger: Gitea Webhook / Poll SCM
Build: Execute shell (prepare files)
Deploy: SSH Transfer to storage-server
Target: /var/www/html
Post-Deploy: Fix ownership and permissions
```

---

## 📚 References

- Jenkins Documentation: https://www.jenkins.io/doc/
- Gitea Documentation: https://docs.gitea.io/
- Apache httpd Documentation: https://httpd.apache.org/docs/

---

## 👥 Team

- **Developer**: sarah (Gitea user, SSH access)
- **DevOps**: Jenkins administrator
- **Project**: Nautilus App Deployment Automation

---

## 📅 Project Status

**Status**: ✅ Completed  
**Last Updated**: December 2025  
**Version**: 1.0

---

*This README provides complete documentation for the Nautilus application automated deployment setup. For issues or questions, please refer to the troubleshooting section or contact the DevOps team.*
