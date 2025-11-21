# Jenkins Apache Logs Copy Job - Setup Guide

## Objective
Set up a Jenkins job to periodically copy Apache logs from App Server 3 to the Storage Server for centralized log management.

## Prerequisites
- Jenkins UI access (admin/Adm!n321)
- SSH access between Jenkins and target servers
- Apache installed on App Server 3
- Write permissions on Storage Server at `/usr/src/security`

---

## Step-by-Step Configuration

### 1. Access Jenkins UI
1. Click on the **Jenkins button** on the top bar
2. Login with credentials:
   - **Username**: `admin`
   - **Password**: `Adm!n321`

### 2. Install Required Plugins
Before creating the job, ensure the following plugins are installed:

1. Navigate to **Manage Jenkins** → **Manage Plugins** → **Available** tab
2. Search and install these plugins (if not already installed):
   - **SSH Agent Plugin** (for SSH key-based authentication)
   - **Publish Over SSH Plugin** (for copying files via SSH)
   - **Build Timeout Plugin** (optional, for job timeout management)

3. After installation:
   - Check **"Restart Jenkins when installation is complete and no jobs are running"**
   - Wait for Jenkins to restart
   - **Refresh the browser page** if the UI gets stuck

### 3. Configure SSH Connection to Servers

#### Option A: Using "Publish Over SSH" Plugin
1. Go to **Manage Jenkins** → **Configure System**
2. Scroll down to **Publish over SSH** section
3. Click **Add SSH Server**
4. Configure Storage Server:
   - **Name**: `storage-server`
   - **Hostname**: `<Storage Server IP/hostname>`
   - **Username**: `<SSH username>`
   - **Remote Directory**: `/usr/src/security`
5. Configure App Server 3:
   - **Name**: `app-server-3`
   - **Hostname**: `<App Server 3 IP/hostname>`
   - **Username**: `<SSH username>`
6. Add SSH credentials (password or private key)
7. Click **Test Configuration** to verify connectivity
8. Click **Save**

#### Option B: Using SSH Credentials
1. Go to **Manage Jenkins** → **Manage Credentials**
2. Click on **(global)** domain
3. Click **Add Credentials**
4. Select **SSH Username with private key**
5. Enter:
   - **ID**: `ssh-key-servers`
   - **Username**: `<SSH username>`
   - **Private Key**: Enter directly or from file
6. Click **OK**

### 4. Create Jenkins Job

1. From Jenkins Dashboard, click **New Item**
2. Enter job name: **`copy-logs`**
3. Select **Freestyle project**
4. Click **OK**

### 5. Configure Job Settings

#### General Settings
- **Description**: "Periodically copy Apache access and error logs from App Server 3 to Storage Server"

#### Build Triggers
1. Check **Build periodically**
2. Enter Schedule (cron expression):
   ```
   */9 * * * *
   ```
   This runs the job every 9 minutes.

   **Cron Expression Explanation**:
   - `*/9` - Every 9 minutes
   - `*` - Every hour
   - `*` - Every day of month
   - `*` - Every month
   - `*` - Every day of week

#### Build Environment (Optional)
- Check **Delete workspace before build starts** (for clean execution)
- Check **Add timestamps to the Console Output**

#### Build Steps

**Method 1: Using "Send files over SSH" (Recommended if using Publish Over SSH plugin)**

1. Click **Add build step** → **Send files over SSH**
2. Configure:
   - **SSH Server**: Select configured server
   - **Source files**: Configure to copy from remote server
   
**Method 2: Using Shell Script (More Flexible)**

1. Click **Add build step** → **Execute shell**
2. Add the following script:

```bash
#!/bin/bash

# Variables
APP_SERVER="<app-server-3-hostname-or-ip>"
APP_SERVER_USER="<ssh-username>"
STORAGE_SERVER="<storage-server-hostname-or-ip>"
STORAGE_SERVER_USER="<ssh-username>"
APACHE_LOG_DIR="/var/log/httpd"  # Default Apache logs location (RHEL/CentOS)
# For Ubuntu/Debian, use: /var/log/apache2
DEST_DIR="/usr/src/security"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "Starting Apache logs copy process..."
echo "Timestamp: $TIMESTAMP"

# Create temporary directory on Jenkins server
TEMP_DIR="/tmp/apache_logs_${TIMESTAMP}"
mkdir -p ${TEMP_DIR}

# Copy logs from App Server 3 to Jenkins server
echo "Copying logs from App Server 3..."
scp -o StrictHostKeyChecking=no ${APP_SERVER_USER}@${APP_SERVER}:${APACHE_LOG_DIR}/access_log ${TEMP_DIR}/access_log_${TIMESTAMP} || {
    echo "Warning: Failed to copy access_log"
}

scp -o StrictHostKeyChecking=no ${APP_SERVER_USER}@${APP_SERVER}:${APACHE_LOG_DIR}/error_log ${TEMP_DIR}/error_log_${TIMESTAMP} || {
    echo "Warning: Failed to copy error_log"
}

# Check if logs were copied
if [ "$(ls -A ${TEMP_DIR})" ]; then
    echo "Logs copied successfully to temporary directory"
    
    # Copy logs from Jenkins server to Storage Server
    echo "Copying logs to Storage Server..."
    scp -o StrictHostKeyChecking=no ${TEMP_DIR}/* ${STORAGE_SERVER_USER}@${STORAGE_SERVER}:${DEST_DIR}/ || {
        echo "ERROR: Failed to copy logs to Storage Server"
        exit 1
    }
    
    echo "Logs successfully copied to Storage Server: ${DEST_DIR}"
    
    # Verify on Storage Server
    echo "Verifying files on Storage Server..."
    ssh -o StrictHostKeyChecking=no ${STORAGE_SERVER_USER}@${STORAGE_SERVER} "ls -lh ${DEST_DIR}/*${TIMESTAMP}*"
    
else
    echo "ERROR: No logs found to copy"
    exit 1
fi

# Cleanup temporary directory
echo "Cleaning up temporary files..."
rm -rf ${TEMP_DIR}

echo "Log copy process completed successfully!"
```

**Alternative Script (Direct Copy)**:
```bash
#!/bin/bash

# Direct copy from App Server 3 to Storage Server
APP_SERVER="<app-server-3-hostname-or-ip>"
APP_SERVER_USER="<ssh-username>"
STORAGE_SERVER="<storage-server-hostname-or-ip>"
STORAGE_SERVER_USER="<ssh-username>"
APACHE_LOG_DIR="/var/log/httpd"
DEST_DIR="/usr/src/security"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "Starting direct log copy from App Server 3 to Storage Server..."

# SSH to Storage Server and pull logs from App Server 3
ssh -o StrictHostKeyChecking=no ${STORAGE_SERVER_USER}@${STORAGE_SERVER} << EOF
echo "Pulling Apache logs from App Server 3..."
scp -o StrictHostKeyChecking=no ${APP_SERVER_USER}@${APP_SERVER}:${APACHE_LOG_DIR}/access_log ${DEST_DIR}/access_log_${TIMESTAMP}
scp -o StrictHostKeyChecking=no ${APP_SERVER_USER}@${APP_SERVER}:${APACHE_LOG_DIR}/error_log ${DEST_DIR}/error_log_${TIMESTAMP}
echo "Logs copied successfully!"
ls -lh ${DEST_DIR}/*${TIMESTAMP}*
EOF

echo "Log copy process completed!"
```

### 6. Post-Build Actions (Optional)

1. Click **Add post-build action** → **E-mail Notification**
2. Configure email alerts for job failures
3. Or add **Editable Email Notification** for more detailed reports

### 7. Save and Test

1. Click **Save**
2. Click **Build Now** to test the job immediately
3. Check **Console Output** to verify execution
4. Verify logs are copied to Storage Server:
   ```bash
   ssh <storage-server> "ls -lh /usr/src/security"
   ```

---

## Default Apache Log Locations

| OS/Distribution | Default Log Directory |
|----------------|----------------------|
| RHEL/CentOS/Fedora | `/var/log/httpd/` |
| Ubuntu/Debian | `/var/log/apache2/` |
| Common Log Files | `access_log` or `access.log`<br>`error_log` or `error.log` |

---

## Troubleshooting

### Issue 1: SSH Connection Failed
**Solution**:
- Verify SSH keys are properly configured
- Check `/var/lib/jenkins/.ssh/known_hosts` for host keys
- Test manual SSH connection: `ssh user@server`
- Ensure Jenkins user has SSH access

### Issue 2: Permission Denied on Storage Server
**Solution**:
```bash
# On Storage Server, ensure directory exists and has correct permissions
sudo mkdir -p /usr/src/security
sudo chown <ssh-user>:<ssh-group> /usr/src/security
sudo chmod 755 /usr/src/security
```

### Issue 3: Logs Not Found on App Server 3
**Solution**:
- Verify Apache is installed and running
- Check actual log location: `sudo find /var/log -name "*access*" -o -name "*error*"`
- Ensure read permissions on log files

### Issue 4: Jenkins UI Stuck After Restart
**Solution**:
- Hard refresh browser: `Ctrl + F5` (Windows/Linux) or `Cmd + Shift + R` (Mac)
- Clear browser cache
- Wait 2-3 minutes for Jenkins to fully restart
- Access directly: `http://<jenkins-url>:<port>/restart`

### Issue 5: Build Fails with SCP Error
**Solution**:
- Check if `scp` command is available on Jenkins server
- Verify network connectivity between servers
- Check firewall rules (port 22 should be open)
- Add `-v` flag to scp for verbose output: `scp -v ...`

---

## Verification Checklist

- [ ] Jenkins job `copy-logs` is created
- [ ] Job is configured to run every 9 minutes (`*/9 * * * *`)
- [ ] SSH connectivity to App Server 3 is working
- [ ] SSH connectivity to Storage Server is working
- [ ] Apache logs are accessible on App Server 3
- [ ] Destination directory `/usr/src/security` exists on Storage Server
- [ ] Manual test build completes successfully
- [ ] Logs appear in `/usr/src/security` on Storage Server
- [ ] Console output shows no errors
- [ ] Scheduled builds are triggering automatically

---

## Monitoring and Maintenance

### Check Job Status
```bash
# View recent builds
Jenkins Dashboard → copy-logs → Build History

# Check console output
Jenkins Dashboard → copy-logs → Latest Build → Console Output
```

### Monitor Log Growth on Storage Server
```bash
ssh storage-server "du -sh /usr/src/security"
```

### Clean Old Logs (Optional Maintenance)
Add a cleanup script to remove logs older than 30 days:
```bash
# On Storage Server
find /usr/src/security -name "*_log_*" -type f -mtime +30 -delete
```

---

## Screenshots to Capture

For review purposes, take screenshots of:

1. **Jenkins Dashboard** showing the `copy-logs` job
2. **Job Configuration** page:
   - Build Triggers section with cron expression
   - Build Steps with the shell script
3. **Successful Build** Console Output
4. **Storage Server** directory listing showing copied logs
5. **Build History** showing periodic executions

---

## Additional Notes

- The job will run automatically every 9 minutes
- Logs are timestamped to prevent overwriting
- Consider implementing log rotation on Storage Server
- Monitor disk space on Storage Server regularly
- Review Jenkins job logs weekly for any issues

---

## Support and Resources

- Jenkins Documentation: https://www.jenkins.io/doc/
- SSH Plugin: https://plugins.jenkins.io/ssh-agent/
- Publish Over SSH: https://plugins.jenkins.io/publish-over-ssh/
- Apache Logs: https://httpd.apache.org/docs/current/logs.html

---

## Contact

For issues or questions, contact the DevOps team at xFusionCorp Industries.

---

**Last Updated**: November 2025
**Version**: 1.0
