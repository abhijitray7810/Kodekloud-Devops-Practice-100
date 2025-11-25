# Jenkins Slave Nodes Setup Guide

## Overview
This guide provides step-by-step instructions for configuring Jenkins slave nodes for all three application servers in the Stratos DC environment.

## Prerequisites
- Jenkins server accessible via the Jenkins button in the top bar
- Admin credentials: `admin` / `Adm!n321`
- SSH access to app servers (stapp01, stapp02, stapp03)
- Required user accounts on app servers: tony, steve, banner

## Task Requirements

### Server Configuration Matrix

| Server Name | Node Name | Label | Remote Root Directory | User |
|------------|-----------|-------|----------------------|------|
| App Server 1 | App_server_1 | stapp01 | /home/tony/jenkins | tony |
| App Server 2 | App_server_2 | stapp02 | /home/steve/jenkins | steve |
| App Server 3 | App_server_3 | stapp03 | /home/banner/jenkins | banner |

## Step-by-Step Implementation

### Phase 1: Initial Setup and Plugin Installation

#### 1. Access Jenkins UI
```
1. Click on the Jenkins button in the top bar
2. Login with credentials:
   Username: admin
   Password: Adm!n321
```

#### 2. Install Required Plugins
Navigate to: **Manage Jenkins → Manage Plugins → Available**

Required plugins:
- **SSH Build Agents Plugin** (or SSH Slaves Plugin)
- **SSH Agent Plugin**
- **Credentials Plugin** (usually pre-installed)

Steps:
```
1. Go to Manage Jenkins → Manage Plugins
2. Click on the "Available" tab
3. Search for "SSH Build Agents" or "SSH Slaves"
4. Check the checkbox next to the plugin
5. Click "Install without restart" or "Download now and install after restart"
6. Once installation completes, check "Restart Jenkins when installation is complete and no jobs are running"
7. Wait for Jenkins to restart (refresh the page if UI gets stuck)
8. Log back in with admin credentials
```

### Phase 2: Prepare App Servers

#### 1. SSH into Each App Server
You'll need to create the Jenkins working directories on each server.

**For App Server 1 (stapp01):**
```bash
ssh tony@stapp01
mkdir -p /home/tony/jenkins
chmod 755 /home/tony/jenkins
exit
```

**For App Server 2 (stapp02):**
```bash
ssh steve@stapp02
mkdir -p /home/steve/jenkins
chmod 755 /home/steve/jenkins
exit
```

**For App Server 3 (stapp03):**
```bash
ssh banner@stapp03
mkdir -p /home/banner/jenkins
chmod 755 /home/banner/jenkins
exit
```

#### 2. Generate SSH Keys (if not already available)
On the Jenkins server or from your control machine:
```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -C "jenkins@stratos" -f ~/.ssh/jenkins_key -N ""

# Copy public key to each app server
ssh-copy-id -i ~/.ssh/jenkins_key.pub tony@stapp01
ssh-copy-id -i ~/.ssh/jenkins_key.pub steve@stapp02
ssh-copy-id -i ~/.ssh/jenkins_key.pub banner@stapp03

# Verify SSH access
ssh -i ~/.ssh/jenkins_key tony@stapp01 "echo 'Connection successful'"
ssh -i ~/.ssh/jenkins_key steve@stapp02 "echo 'Connection successful'"
ssh -i ~/.ssh/jenkins_key banner@stapp03 "echo 'Connection successful'"
```

### Phase 3: Add SSH Credentials in Jenkins

#### 1. Navigate to Credentials
```
Manage Jenkins → Manage Credentials → (global) → Add Credentials
```

#### 2. Create Credentials for Each Server

**Credential 1: For tony@stapp01**
```
Kind: SSH Username with private key
Scope: Global
ID: ssh-tony-stapp01
Description: SSH key for tony on App Server 1
Username: tony
Private Key: Enter directly (paste the private key from ~/.ssh/jenkins_key)
```

**Credential 2: For steve@stapp02**
```
Kind: SSH Username with private key
Scope: Global
ID: ssh-steve-stapp02
Description: SSH key for steve on App Server 2
Username: steve
Private Key: Enter directly (paste the same private key)
```

**Credential 3: For banner@stapp03**
```
Kind: SSH Username with private key
Scope: Global
ID: ssh-banner-stapp03
Description: SSH key for banner on App Server 3
Username: banner
Private Key: Enter directly (paste the same private key)
```

### Phase 4: Add Slave Nodes

#### Add App_server_1 (stapp01)

1. Navigate to: **Manage Jenkins → Manage Nodes and Clouds → New Node**

2. Configure node:
```
Node name: App_server_1
Type: Permanent Agent
Click "OK"
```

3. Node Configuration:
```
Name: App_server_1
Description: Application Server 1 - stapp01
Number of executors: 2 (or as needed)
Remote root directory: /home/tony/jenkins
Labels: stapp01
Usage: Use this node as much as possible (or Only build jobs with label expressions matching this node)

Launch method: Launch agents via SSH
  Host: stapp01
  Credentials: tony (SSH key for tony on App Server 1)
  Host Key Verification Strategy: Non verifying Verification Strategy (or Manually trusted key)
  
Availability: Keep this agent online as much as possible
```

4. Click **Save**

#### Add App_server_2 (stapp02)

1. Navigate to: **Manage Jenkins → Manage Nodes and Clouds → New Node**

2. Configure node:
```
Node name: App_server_2
Type: Permanent Agent
Click "OK"
```

3. Node Configuration:
```
Name: App_server_2
Description: Application Server 2 - stapp02
Number of executors: 2 (or as needed)
Remote root directory: /home/steve/jenkins
Labels: stapp02
Usage: Use this node as much as possible

Launch method: Launch agents via SSH
  Host: stapp02
  Credentials: steve (SSH key for steve on App Server 2)
  Host Key Verification Strategy: Non verifying Verification Strategy
  
Availability: Keep this agent online as much as possible
```

4. Click **Save**

#### Add App_server_3 (stapp03)

1. Navigate to: **Manage Jenkins → Manage Nodes and Clouds → New Node**

2. Configure node:
```
Node name: App_server_3
Type: Permanent Agent
Click "OK"
```

3. Node Configuration:
```
Name: App_server_3
Description: Application Server 3 - stapp03
Number of executors: 2 (or as needed)
Remote root directory: /home/banner/jenkins
Labels: stapp03
Usage: Use this node as much as possible

Launch method: Launch agents via SSH
  Host: stapp03
  Credentials: banner (SSH key for banner on App Server 3)
  Host Key Verification Strategy: Non verifying Verification Strategy
  
Availability: Keep this agent online as much as possible
```

4. Click **Save**

### Phase 5: Verification

#### 1. Check Node Status
Navigate to: **Manage Jenkins → Manage Nodes and Clouds**

You should see:
- Built-In Node
- App_server_1 (stapp01) - Status should show online with a sync icon
- App_server_2 (stapp02) - Status should show online with a sync icon
- App_server_3 (stapp03) - Status should show online with a sync icon

#### 2. Test Each Node

Click on each node and verify:
- Log shows successful connection
- No error messages
- Node is marked as "In sync"

Example log output for successful connection:
```
SSHLauncher{host='stapp01', port=22, credentialsId='ssh-tony-stapp01', ...}
[11/26/25 10:30:00] [SSH] Opening SSH connection to stapp01:22.
[11/26/25 10:30:01] [SSH] SSH host key matches key seen previously for this host. Connection will be allowed.
[11/26/25 10:30:01] [SSH] Authentication successful.
[11/26/25 10:30:01] [SSH] The remote user's environment is:
...
Agent successfully connected and online
```

#### 3. Create Test Job (Optional)

Create a simple test job to verify nodes are working:

```
Job Configuration:
- Type: Freestyle project
- Name: test-slave-nodes
- Restrict where this project can be run: Check this box
  Label Expression: stapp01 || stapp02 || stapp03
- Build Steps → Execute shell:
  echo "Running on node: $NODE_NAME"
  echo "Running on host: $(hostname)"
  pwd
```

Run the job multiple times and verify it runs on different nodes.

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: Plugin Not Found
**Solution:** 
- Make sure you're searching in the "Available" tab
- Try searching for "SSH Agent" or "SSH Slaves" 
- Refresh the plugin list

#### Issue 2: Node Shows Offline
**Solution:**
```
1. Click on the node name
2. Check the log for error messages
3. Common fixes:
   - Verify SSH connectivity: ssh user@host
   - Check if remote directory exists and has correct permissions
   - Verify credentials are correct
   - Check if Java is installed on the slave node: java -version
```

#### Issue 3: Authentication Failed
**Solution:**
```
1. Verify SSH key is correctly copied to the server
2. Test SSH connection manually: ssh -i /path/to/key user@host
3. Check SSH key permissions (should be 600)
4. Verify username matches the one in credentials
```

#### Issue 4: Directory Permission Denied
**Solution:**
```bash
# On the app server
chmod 755 /home/user/jenkins
chown user:user /home/user/jenkins
```

#### Issue 5: Java Not Found on Agent
**Solution:**
```bash
# Install Java on the app server
sudo yum install java-11-openjdk -y  # For RHEL/CentOS
# or
sudo apt-get install openjdk-11-jdk -y  # For Ubuntu/Debian
```

#### Issue 6: Jenkins UI Stuck After Restart
**Solution:**
```
1. Wait 1-2 minutes for Jenkins to fully restart
2. Clear browser cache
3. Refresh the page (Ctrl+F5 or Cmd+Shift+R)
4. If still stuck, navigate directly to: http://jenkins-url/login
```

## Validation Checklist

- [ ] SSH Build Agents plugin installed
- [ ] Jenkins restarted successfully after plugin installation
- [ ] All three app servers have Jenkins directories created
- [ ] SSH credentials added for all three users
- [ ] App_server_1 node created with label stapp01
- [ ] App_server_2 node created with label stapp02
- [ ] App_server_3 node created with label stapp03
- [ ] All three nodes show "online" status
- [ ] Node logs show successful connections
- [ ] Test job runs successfully on all nodes

## Best Practices

1. **Screenshots**: Take screenshots at each major step, especially:
   - Plugin installation confirmation
   - Each node configuration page
   - Node status page showing all nodes online
   - Successful test job execution

2. **Screen Recording**: Consider using tools like:
   - Loom.com
   - OBS Studio
   - Browser extensions (Screencastify, Loom extension)

3. **Security Considerations**:
   - Use separate SSH keys for different environments
   - Regularly rotate SSH keys
   - Use "Known hosts file Verification Strategy" in production
   - Limit executor count based on server resources

4. **Maintenance**:
   - Monitor node disk space
   - Clean up old workspaces periodically
   - Update Jenkins and plugins regularly
   - Review node logs for issues

## Additional Resources

- [Jenkins SSH Build Agents Plugin Documentation](https://plugins.jenkins.io/ssh-slaves/)
- [Jenkins Distributed Builds](https://www.jenkins.io/doc/book/using/using-agents/)
- [SSH Key Management](https://www.jenkins.io/doc/book/using/using-credentials/)

## Summary

This guide covered:
1. Installing required Jenkins plugins
2. Preparing app servers with Jenkins directories
3. Setting up SSH credentials in Jenkins
4. Adding three slave nodes with specific configurations
5. Verifying nodes are online and operational
6. Troubleshooting common issues

All three app servers should now be successfully configured as Jenkins slave nodes and ready for CI/CD tasks and automation workflows.
