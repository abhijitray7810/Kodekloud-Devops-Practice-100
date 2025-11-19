# Jenkins Package Installation Job - Nautilus Infrastructure

## Overview
This document provides comprehensive instructions for creating and configuring a Jenkins job to automate package installation on the storage server within the Stratos Datacenter.

## Prerequisites
- Jenkins server installed and running
- Access to Jenkins UI
- SSH connectivity to the storage server
- Administrative credentials for Jenkins

## Task Requirements
Create a Jenkins job named `install-packages` that:
- Accepts a package name as a parameter
- Installs the specified package on the storage server
- Can be executed multiple times reliably

---

## Step-by-Step Configuration

### Step 1: Access Jenkins UI

1. Click on the **Jenkins** button in the top bar
2. Log in using the following credentials:
   - **Username:** `admin`
   - **Password:** `Adm!n321`

### Step 2: Create New Jenkins Job

1. From the Jenkins dashboard, click **"New Item"**
2. Enter the job name: `install-packages`
3. Select **"Freestyle project"**
4. Click **"OK"**

### Step 3: Configure Job Parameters

1. In the job configuration page, locate **"General"** section
2. Check the box **"This project is parameterized"**
3. Click **"Add Parameter"** → Select **"String Parameter"**
4. Configure the parameter:
   - **Name:** `PACKAGE`
   - **Default Value:** (leave empty or set a default package)
   - **Description:** `Name of the package to install on storage server`

### Step 4: Configure Build Step

1. Scroll down to the **"Build"** section
2. Click **"Add build step"** → Select **"Execute shell"**
3. Enter the following script:

```bash
#!/bin/bash
# Install package on storage server in Stratos Datacenter
ssh -o StrictHostKeyChecking=no natasha@ststor01 "sudo yum install -y $PACKAGE"
```

**Alternative scripts based on your environment:**

**Option A: Using sshpass (if SSH keys not configured)**
```bash
#!/bin/bash
sshpass -p 'Bl@kW' ssh -o StrictHostKeyChecking=no natasha@ststor01 "sudo yum install -y $PACKAGE"
```

**Option B: Using different package manager (for Debian/Ubuntu)**
```bash
#!/bin/bash
ssh -o StrictHostKeyChecking=no natasha@ststor01 "sudo apt-get update && sudo apt-get install -y $PACKAGE"
```

**Option C: With error handling**
```bash
#!/bin/bash
set -e
echo "Installing package: $PACKAGE on storage server..."
ssh -o StrictHostKeyChecking=no natasha@ststor01 "sudo yum install -y $PACKAGE"
if [ $? -eq 0 ]; then
    echo "Package $PACKAGE installed successfully"
else
    echo "Failed to install package $PACKAGE"
    exit 1
fi
```

### Step 5: Save Configuration

1. Scroll to the bottom of the page
2. Click **"Save"**

---

## Required Plugins

The following plugins may need to be installed:

1. **Parameterized Build Plugin** (usually pre-installed)
2. **SSH Agent Plugin** (optional, for SSH key management)
3. **Credentials Plugin** (optional, for secure credential storage)

### Installing Plugins

1. Go to **"Manage Jenkins"** → **"Manage Plugins"**
2. Click on **"Available"** tab
3. Search for the required plugin
4. Check the plugin checkbox
5. Click **"Install without restart"** or **"Download now and install after restart"**
6. If needed, select **"Restart Jenkins when installation is complete and no jobs are running"**
7. Wait for Jenkins to restart
8. Refresh the browser page after restart

---

## Testing the Job

### First Test Run

1. Navigate to the `install-packages` job page
2. Click **"Build with Parameters"**
3. Enter a test package name:
   - Example: `wget`
   - Example: `curl`
   - Example: `git`
4. Click **"Build"**
5. Click on the build number (e.g., #1) to view details
6. Click **"Console Output"** to monitor execution

### Verify Success

Check the console output for:
- Successful SSH connection
- Package installation messages
- No error messages
- Exit code 0

### Multiple Test Runs

Execute the job multiple times with different packages to ensure reliability:
- Test 1: `wget`
- Test 2: `curl`
- Test 3: `vim`
- Test 4: Re-install `wget` (should handle already installed packages)

---

## Environment Details

### Stratos Datacenter Storage Server

- **Hostname:** `ststor01`
- **User:** `natasha`
- **Password:** `Bl@kW` (typical for Stratos environment)
- **OS:** CentOS/RHEL (uses yum package manager)
- **Sudo Access:** Required for package installation

---

## Troubleshooting

### SSH Connection Issues

**Problem:** Cannot connect to storage server

**Solutions:**
1. Verify network connectivity:
   ```bash
   ping ststor01
   ```
2. Test SSH manually:
   ```bash
   ssh natasha@ststor01
   ```
3. Check SSH service status on storage server:
   ```bash
   systemctl status sshd
   ```

### Permission Denied Errors

**Problem:** User doesn't have sudo privileges

**Solutions:**
1. Verify sudo access for the user
2. Check sudoers configuration
3. Try using root user if permitted

### Package Not Found

**Problem:** Package doesn't exist in repositories

**Solutions:**
1. Verify package name spelling
2. Update yum cache: `sudo yum clean all && sudo yum makecache`
3. Check enabled repositories: `yum repolist`

### SSH Key Authentication

**Problem:** Password authentication failing

**Solutions:**
1. Set up SSH key-based authentication:
   ```bash
   ssh-keygen -t rsa
   ssh-copy-id natasha@ststor01
   ```
2. Configure Jenkins credentials for SSH keys
3. Use SSH Agent plugin for key management

---

## Security Best Practices

1. **Use SSH Keys:** Configure passwordless SSH authentication instead of passwords
2. **Jenkins Credentials:** Store SSH credentials in Jenkins Credentials Manager
3. **Sudo Configuration:** Configure passwordless sudo for package installation user
4. **Audit Logging:** Enable Jenkins audit logging for security compliance
5. **Parameter Validation:** Consider adding input validation to prevent malicious package names

---

## Advanced Configuration

### Adding Post-Build Actions

1. **Email Notification:**
   - Add post-build action → Email Notification
   - Enter recipient email addresses

2. **Archive Artifacts:**
   - Add post-build action → Archive the artifacts
   - Specify files to archive (e.g., build logs)

3. **Build History:**
   - Configure to keep last N builds
   - Discard old builds automatically

### Scheduling Builds

To run the job on a schedule:
1. In job configuration, check **"Build periodically"**
2. Enter cron syntax (e.g., `H 2 * * *` for daily at 2 AM)

---

## Documentation

### Screenshots to Capture

1. Jenkins login page
2. New Item creation page with job name
3. Job configuration - General section with parameter
4. Job configuration - Build section with shell script
5. Build with Parameters page
6. Console Output of successful build
7. Build History showing multiple successful runs

### Screen Recording

For comprehensive documentation, use [loom.com](https://loom.com) to record:
- Complete job creation process
- Parameter configuration
- Build execution
- Console output review

---

## Verification Checklist

- [ ] Jenkins UI accessible and logged in
- [ ] Job `install-packages` created
- [ ] String parameter `PACKAGE` configured
- [ ] Build step with shell script added
- [ ] Required plugins installed
- [ ] Jenkins service restarted (if needed)
- [ ] Job executed successfully at least once
- [ ] Job executed multiple times for reliability
- [ ] Screenshots/recording captured
- [ ] Console output shows successful installation

---

## Additional Resources

- [Jenkins Official Documentation](https://www.jenkins.io/doc/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [SSH Agent Plugin Documentation](https://plugins.jenkins.io/ssh-agent/)
- [Parameterized Build Plugin](https://plugins.jenkins.io/parameterized-trigger/)

---

## Support

For issues or questions:
- Review Jenkins console output for error messages
- Check Jenkins system logs: `Manage Jenkins` → `System Log`
- Verify storage server accessibility and credentials
- Contact Nautilus DevOps team for infrastructure-specific issues

---

**Document Version:** 1.0  
**Last Updated:** November 2025  
**Maintained By:** Nautilus DevOps Team
