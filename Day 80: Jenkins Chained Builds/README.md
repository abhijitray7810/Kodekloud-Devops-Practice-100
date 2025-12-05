# Jenkins Chained Jobs for Apache Deployment - README

## Overview

This project configures Jenkins chained jobs to automate web application deployment and Apache service management across multiple app servers in the Stratos Datacenter. The solution uses a downstream job pattern where service restarts are triggered only after successful deployments.

## Architecture

```
Gitea Repository (web) 
    ↓
nautilus-app-deployment (Jenkins Job)
    ↓ (pulls code to /var/www/html on Storage server)
    ↓ (triggers if stable)
manage-services (Jenkins Job)
    ↓ (restarts httpd on all app servers)
App Servers (stapp01, stapp02, stapp03)
```

## Environment Details

### Access Credentials

| Service | URL/Port | Username | Password |
|---------|----------|----------|----------|
| Jenkins UI | Top bar button | admin | Adm!n321 |
| Gitea UI | Port 8090 | sarah | Sarah_pass123 |
| Application | Top bar button | - | - |

### Infrastructure

- **Storage Server**: Hosts `/var/www/html` (shared volume with all app servers)
- **App Servers**: stapp01, stapp02, stapp03 (Apache pre-installed)
- **Git Repository**: `web` repository under user `sarah`
- **Load Balancer**: Pre-configured, accessible via App button

## Prerequisites

Before starting, ensure:
- Jenkins is running and accessible
- Git repository exists in Gitea under user `sarah`
- `/var/www/html` on Storage server is a local Git repository tracking origin
- Apache (httpd) is installed on all app servers
- SSH access configured between servers

## Installation Steps

### Step 1: Install Required Jenkins Plugins

1. Navigate to **Manage Jenkins** → **Manage Plugins** → **Available** tab
2. Search and install these plugins:
   - **Git Plugin** (for Git integration)
   - **Parameterized Trigger Plugin** (for downstream jobs)
   - **SSH Agent Plugin** (optional, for SSH credentials)
3. Check **"Restart Jenkins when installation is complete and no jobs are running"**
4. Wait for Jenkins to restart (refresh browser if UI gets stuck)

### Step 2: Configure nautilus-app-deployment Job

#### 2.1 Create the Job

1. Click **New Item** from Jenkins dashboard
2. Enter item name: `nautilus-app-deployment`
3. Select **Freestyle project**
4. Click **OK**

#### 2.2 Configure Source Code Management

- Select **Git**
- **Repository URL**: `/var/www/html`
  - This is a local repository path, not a remote URL
  - No credentials needed for local repositories
- **Branches to build**
  - Branch Specifier: `*/master`

#### 2.3 Configure Build Step

Click **Add build step** → **Execute shell**

```bash
#!/bin/bash
# Navigate to the web root directory
cd /var/www/html

# Pull latest changes from master branch
sudo git pull origin master

# Set proper ownership for Apache
sudo chown -R apache:apache /var/www/html

# Set proper permissions
sudo chmod -R 755 /var/www/html

# Verify deployment
echo "==================================="
echo "Deployment completed successfully!"
echo "==================================="
ls -la /var/www/html
```

#### 2.4 Configure Post-build Actions

Click **Add post-build action** → **Build other projects**

- **Projects to build**: `manage-services`
- **Trigger only if build is stable**: ✓ (checked)

Click **Save**

### Step 3: Configure manage-services Job

#### 3.1 Create the Job

1. Click **New Item** from Jenkins dashboard
2. Enter item name: `manage-services`
3. Select **Freestyle project**
4. Click **OK**

#### 3.2 Configure Build Step

Click **Add build step** → **Execute shell**

```bash
#!/bin/bash

# Define app servers
APP_SERVERS=("stapp01" "stapp02" "stapp03")

echo "========================================="
echo "Starting Apache service restart on all app servers"
echo "========================================="

# Restart httpd service on each app server
for server in "${APP_SERVERS[@]}"; do
    echo "Processing server: $server"
    
    # Restart httpd service via SSH
    sudo ssh -o StrictHostKeyChecking=no $server "systemctl restart httpd"
    
    # Check if restart was successful
    if [ $? -eq 0 ]; then
        echo "✓ Successfully restarted httpd on $server"
    else
        echo "✗ Failed to restart httpd on $server"
        exit 1
    fi
    
    # Verify service is running
    sudo ssh -o StrictHostKeyChecking=no $server "systemctl status httpd | grep 'Active:'"
    echo "---"
done

echo "========================================="
echo "All services restarted successfully!"
echo "========================================="
```

**Alternative script (if direct SSH from Jenkins works):**

```bash
#!/bin/bash
# Restart httpd on all app servers
for server in stapp01 stapp02 stapp03; do
    echo "Restarting httpd on $server..."
    sudo ssh -o StrictHostKeyChecking=no $server "systemctl restart httpd" && \
    echo "✓ Success on $server" || { echo "✗ Failed on $server"; exit 1; }
done
echo "All services restarted successfully!"
```

Click **Save**

## Configuration Requirements

### Sudo Permissions

Ensure Jenkins user has sudo privileges without password prompt:

```bash
# On Storage server, edit sudoers file
sudo visudo

# Add this line (adjust based on your Jenkins user)
jenkins ALL=(ALL) NOPASSWD: ALL
```

### SSH Key Configuration (if needed)

If SSH authentication is required:

```bash
# On Storage server as Jenkins user
sudo su - jenkins
ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa

# Copy SSH key to all app servers
for server in stapp01 stapp02 stapp03; do
    ssh-copy-id root@$server
done

# Test SSH connectivity
ssh stapp01 "hostname"
ssh stapp02 "hostname"
ssh stapp03 "hostname"
```

### Git Repository Setup

Ensure `/var/www/html` is properly configured:

```bash
cd /var/www/html

# Verify it's a Git repository
git status

# Check remote configuration
git remote -v

# Should show origin pointing to Gitea repository
# origin  http://gitea:8090/sarah/web.git (fetch)
# origin  http://gitea:8090/sarah/web.git (push)

# If not configured, set it up
git remote add origin http://gitea:8090/sarah/web.git
git pull origin master
```

## Testing the Setup

### Test 1: Deployment Job

1. Go to Jenkins → **nautilus-app-deployment**
2. Click **Build Now**
3. Click on the build number (e.g., #1) to view details
4. Click **Console Output**
5. Verify output shows:
   - Git pull successful
   - Files updated
   - Deployment completed message
   - Build status: **SUCCESS**

### Test 2: Downstream Trigger

1. After `nautilus-app-deployment` completes successfully
2. Check **Downstream Projects** section on build page
3. `manage-services` should automatically start
4. Verify it triggered only after upstream was stable

### Test 3: Service Restart

1. Go to Jenkins → **manage-services**
2. View the triggered build
3. Check **Console Output**
4. Verify output shows:
   - Each server processed
   - Success messages for all servers
   - Services restarted

### Test 4: Application Verification

1. Click the **App** button on the top bar
2. Verify the application loads correctly
3. Ensure URL is direct (e.g., `https://example.com/`)
   - NOT a subdirectory like `https://example.com/web/`
4. Check that latest changes from Git are visible

### Test 5: Repetitive Builds

1. Run `nautilus-app-deployment` multiple times
2. Verify each build passes successfully
3. Ensure no errors on subsequent runs
4. Confirm idempotent behavior

## Workflow

### Normal Deployment Flow

1. Developer commits changes to Gitea `web` repository
2. Jenkins `nautilus-app-deployment` job is triggered (manually or automatically)
3. Job pulls latest code from Git to `/var/www/html` on Storage server
4. If deployment is **stable**, downstream job `manage-services` is triggered
5. `manage-services` restarts httpd on all app servers (stapp01, stapp02, stapp03)
6. Changes are now live on all servers via shared volume
7. Application accessible through Load Balancer

### Failure Scenarios

**If nautilus-app-deployment fails:**
- Downstream job `manage-services` will NOT trigger
- App servers continue serving old content
- No service disruption

**If manage-services fails:**
- Deployment is complete but services not restarted
- May need manual service restart
- Check console output for specific server failure

## Troubleshooting

### Issue: Git pull fails with permission denied

**Solution:**
```bash
# Ensure Jenkins user has permissions
sudo chown -R jenkins:jenkins /var/www/html
sudo chmod -R 755 /var/www/html

# Ensure sudo is configured
sudo visudo
# Add: jenkins ALL=(ALL) NOPASSWD: ALL
```

### Issue: Downstream job doesn't trigger

**Solution:**
- Verify "Build other projects" is configured in nautilus-app-deployment
- Check spelling of downstream job name (case-sensitive)
- Ensure "Trigger only if build is stable" is checked
- Verify Parameterized Trigger Plugin is installed

### Issue: SSH connection fails to app servers

**Solution:**
```bash
# Test SSH manually
sudo ssh stapp01 "hostname"

# If fails, check SSH keys
sudo su - jenkins
ssh-keygen -t rsa
ssh-copy-id stapp01
ssh-copy-id stapp02
ssh-copy-id stapp03

# Verify known_hosts
cat ~/.ssh/known_hosts
```

### Issue: httpd service fails to restart

**Solution:**
```bash
# Verify service name (httpd vs apache2)
systemctl list-units | grep -i apache

# Check service status manually
sudo ssh stapp01 "systemctl status httpd"

# Check for configuration errors
sudo ssh stapp01 "httpd -t"

# Check sudo permissions for systemctl
sudo visudo
```

### Issue: Application shows old content

**Solution:**
```bash
# Verify shared volume is working
ls -la /var/www/html

# On app servers, check if volume is mounted
df -h | grep html

# Verify Apache is reading from correct directory
grep DocumentRoot /etc/httpd/conf/httpd.conf

# Clear browser cache and reload
```

### Issue: Jenkins UI stuck after restart

**Solution:**
- Wait 2-3 minutes for Jenkins to fully restart
- Hard refresh browser (Ctrl+F5 or Cmd+Shift+R)
- Clear browser cache
- Try accessing in incognito/private window

## Validation Checklist

- [ ] Parameterized Trigger Plugin installed
- [ ] `nautilus-app-deployment` job created
- [ ] Git repository configured with correct path
- [ ] Build script uses sudo for git pull
- [ ] Proper file permissions set (apache:apache, 755)
- [ ] Post-build action configured to trigger downstream job
- [ ] "Trigger only if build is stable" option selected
- [ ] `manage-services` job created
- [ ] Service restart script configured for all app servers
- [ ] SSH access working between Storage and app servers
- [ ] Both jobs pass on first run
- [ ] Jobs are idempotent (pass on repetitive runs)
- [ ] Application accessible via main URL
- [ ] Latest Git changes visible in application
- [ ] No subdirectory in URL path

## Screenshots for Documentation

Capture screenshots of:

1. **Jenkins Dashboard** showing both jobs
2. **nautilus-app-deployment Configuration**:
   - Source Code Management section
   - Build section (shell script)
   - Post-build Actions section
3. **manage-services Configuration**:
   - Build section (shell script)
4. **Successful Build Output**:
   - nautilus-app-deployment console output
   - manage-services console output
5. **Build History** showing successful chain
6. **Application URL** displaying latest changes

## Best Practices

1. **Always use sudo** for operations requiring elevated privileges
2. **Test SSH connectivity** before configuring Jenkins jobs
3. **Use idempotent scripts** that can run multiple times safely
4. **Add error handling** in shell scripts with exit codes
5. **Include verbose output** in scripts for debugging
6. **Verify each step** before moving to the next
7. **Take screenshots** at each major configuration step
8. **Test repetitive runs** to ensure consistency

## Additional Resources

- Jenkins Documentation: https://www.jenkins.io/doc/
- Git Documentation: https://git-scm.com/doc
- Apache HTTP Server: https://httpd.apache.org/docs/

## Notes

- The shared volume `/var/www/html` ensures all app servers have identical content
- Only Apache service needs restart to pick up file changes
- The "stable" trigger prevents service restarts after failed deployments
- Jobs must handle repetitive execution for validation tests
- Always specify `sudo` user in deployment scripts to avoid permission issues

## Support

If you encounter issues:
1. Check Console Output in Jenkins for detailed error messages
2. Verify all prerequisites are met
3. Test each component individually (Git, SSH, Apache)
4. Review Jenkins system logs: **Manage Jenkins** → **System Log**
5. Provide screenshots when requesting assistance
