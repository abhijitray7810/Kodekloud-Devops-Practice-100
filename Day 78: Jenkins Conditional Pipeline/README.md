# Jenkins Pipeline Deployment - xFusionCorp Industries

## 📋 Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
  - [1. Configure Jenkins Slave Node](#1-configure-jenkins-slave-node)
  - [2. Create Jenkins Pipeline Job](#2-create-jenkins-pipeline-job)
  - [3. Install Required Plugins](#3-install-required-plugins)
- [Pipeline Script](#pipeline-script)
- [Usage](#usage)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Notes](#notes)

## Overview

This project sets up a Jenkins pipeline to deploy a static website from the `web_app` repository to Nautilus App Servers. The pipeline conditionally deploys code from either the `master` or `feature` branch based on user input.

## Prerequisites

- **Jenkins Access:** Username: `admin`, Password: `Adm!n321`
- **Gitea Access:** Username: `sarah`, Password: `Sarah_pass123`
- **Repository:** `web_app` (cloned at `/var/www/html` on Storage Server)
- **Apache:** Running on port 8080 on all App Servers
- **Storage Server:** Available for slave node configuration

## Setup Instructions

### 1. Configure Jenkins Slave Node

1. Navigate to **Manage Jenkins** → **Manage Nodes and Clouds**
2. Click **New Node**
3. Enter node name: `Storage Server`
4. Select **Permanent Agent** → Click **OK**
5. Configure the node:
   - **Remote root directory:** `/var/www/html`
   - **Labels:** `ststor01`
   - **Usage:** Use this node as much as possible
   - **Launch method:** Launch agents via SSH (recommended)
     - Add Storage Server credentials
     - Configure host and SSH settings
6. Click **Save**

### 2. Create Jenkins Pipeline Job

1. From Jenkins Dashboard, click **New Item**
2. Enter name: `xfusion-webapp-job`
3. Select **Pipeline** (NOT Multibranch Pipeline)
4. Click **OK**

#### Configure String Parameter

1. Check **This project is parameterized**
2. Click **Add Parameter** → **String Parameter**
3. Set **Name:** `BRANCH`
4. Add description: `Branch to deploy (master or feature)`
5. Click **Save**

#### Add Pipeline Script

In the **Pipeline** section, add the following script:

```groovy
pipeline {
    agent {
        label 'ststor01'
    }
    
    stages {
        stage('Deploy') {
            steps {
                script {
                    if (params.BRANCH == 'master') {
                        echo "Deploying master branch..."
                        sh '''
                            cd /var/www/html
                            git checkout master
                            git pull origin master
                        '''
                    } else if (params.BRANCH == 'feature') {
                        echo "Deploying feature branch..."
                        sh '''
                            cd /var/www/html
                            git checkout feature
                            git pull origin feature
                        '''
                    } else {
                        error "Invalid BRANCH parameter. Must be 'master' or 'feature'"
                    }
                }
            }
        }
    }
}
```

### 3. Install Required Plugins

Navigate to **Manage Jenkins** → **Manage Plugins** → **Available**

Install the following plugins:
- Git Plugin
- Pipeline Plugin
- SSH Agent Plugin
- Credentials Plugin

**Important:** Check **"Restart Jenkins when installation is complete and no jobs are running"**

After restart, refresh the browser if the UI appears stuck.

## Pipeline Script

The pipeline script performs the following:

1. **Agent Selection:** Runs on the slave node labeled `ststor01`
2. **Stage: Deploy** (case-sensitive)
   - If `BRANCH=master`: Checks out and pulls master branch
   - If `BRANCH=feature`: Checks out and pulls feature branch
   - If invalid value: Throws error

## Usage

### Deploy Master Branch

1. Go to `xfusion-webapp-job`
2. Click **Build with Parameters**
3. Enter `BRANCH`: `master`
4. Click **Build**

### Deploy Feature Branch

1. Go to `xfusion-webapp-job`
2. Click **Build with Parameters**
3. Enter `BRANCH`: `feature`
4. Click **Build**

## Verification

After successful deployment:

1. Click the **App** button on the top bar
2. Verify content loads at: `https://<LBR-URL>`
3. Ensure content is served from root (NOT `https://<LBR-URL>/web_app`)

✅ **Success Criteria:**
- Pipeline builds successfully
- Correct branch is deployed
- Application accessible without subdirectories
- Latest changes are visible

## Troubleshooting

### Jenkins UI Stuck After Restart
**Solution:** Refresh browser (Ctrl+F5 or Cmd+Shift+R). Wait 30-60 seconds.

### Slave Node Connection Failed
**Solution:** 
- Verify SSH credentials
- Check Storage Server accessibility
- Ensure `/var/www/html` directory exists with proper permissions

### Git Operations Fail
**Solution:**
- Verify git is installed on Storage Server
- Check repository exists at `/var/www/html`
- Verify proper directory permissions

### Content Shows /web_app Directory
**Solution:**
- Verify Apache DocumentRoot is `/var/www/html`
- Check that files are not in a subdirectory
- Review Apache configuration

### Permission Denied Errors
**Solution:**
```bash
chmod -R 755 /var/www/html
chown -R jenkins:jenkins /var/www/html
```

## Notes

⚠️ **Important Reminders:**

1. **Take Screenshots:** Document each configuration step for review
2. **Screen Recording:** Consider using [loom.com](https://loom.com) to record the setup process
3. **Stage Name:** "Deploy" is case-sensitive
4. **Branch Names:** Ensure `master` and `feature` branches exist in repository
5. **No Subdirectories:** Final URL must not include `/web_app` path
6. **Mounted Directory:** `/var/www/html` on Storage Server is mounted to App Servers

## Directory Structure

```
/var/www/html/
├── .git/
├── index.html
├── css/
├── js/
└── ...
```

## Additional Resources

- [Jenkins Pipeline Documentation](https://www.jenkins.io/doc/book/pipeline/)
- [Jenkins Git Plugin](https://plugins.jenkins.io/git/)
- [Apache Documentation](https://httpd.apache.org/docs/)

---

**Project:** xFusionCorp Industries Web App Deployment  
**Version:** 1.0  
**Last Updated:** December 2025
