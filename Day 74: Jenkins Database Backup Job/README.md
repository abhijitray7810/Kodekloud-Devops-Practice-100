# Command Reference for Jenkins Database Backup

## Pre-Configuration Commands

### 1. SSH Key Setup (Already Completed)
```bash
# On jumphost as thor user
ssh-keygen -t ed25519

# Copy SSH key to database server
ssh-copy-id peter@stdb01

# Copy SSH key to backup server
ssh-copy-id clint@stbkp01

# Verify SSH key
ls -lah ~/.ssh/
cat ~/.ssh/id_ed25519
```

### 2. Test SSH Connections
```bash
# Test connection to database server
ssh peter@stdb01

# Test connection to backup server
ssh clint@stbkp01

# Test without password prompt
ssh -o StrictHostKeyChecking=no peter@stdb01 "hostname"
ssh -o StrictHostKeyChecking=no clint@stbkp01 "hostname"
```

## Database Server Commands (stdb01)

### Login to Database Server
```bash
ssh peter@stdb01
```

### MySQL Commands
```bash
# Login to MySQL
mysql -u kodekloud_roy -pasdfgdsd

# Show all databases
mysql -u kodekloud_roy -pasdfgdsd -e "SHOW DATABASES;"

# Show tables in kodekloud_db01
mysql -u kodekloud_roy -pasdfgdsd kodekloud_db01 -e "SHOW TABLES;"

# Get database size
mysql -u kodekloud_roy -pasdfgdsd -e "SELECT table_schema AS 'Database', ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)' FROM information_schema.tables WHERE table_schema = 'kodekloud_db01' GROUP BY table_schema;"
```

### Manual Database Backup
```bash
# Create backup with current date
mysqldump -u kodekloud_roy -pasdfgdsd kodekloud_db01 > /tmp/db_$(date +%F).sql

# Check the backup file
ls -lh /tmp/db_*.sql

# View first few lines of backup
head -20 /tmp/db_$(date +%F).sql
```

### Test mysqldump is available
```bash
which mysqldump
mysqldump --version
```

## Backup Server Commands (stbkp01)

### Login to Backup Server
```bash
ssh clint@stbkp01
```

### Prepare Backup Directory
```bash
# Create backup directory if it doesn't exist
mkdir -p /home/clint/db_backups

# Check directory permissions
ls -ld /home/clint/db_backups

# Set proper permissions
chmod 755 /home/clint/db_backups
```

### Verify Backups
```bash
# List all backup files
ls -lh /home/clint/db_backups/

# List backups sorted by date
ls -lht /home/clint/db_backups/

# Check specific backup file
ls -lh /home/clint/db_backups/db_$(date +%F).sql

# View backup file size
du -sh /home/clint/db_backups/db_*.sql

# Count number of backups
ls /home/clint/db_backups/ | wc -l
```

### Verify Backup Contents
```bash
# View first 20 lines of backup
head -20 /home/clint/db_backups/db_$(date +%F).sql

# Search for specific table in backup
grep "CREATE TABLE" /home/clint/db_backups/db_$(date +%F).sql

# Check if backup is valid SQL
head -1 /home/clint/db_backups/db_$(date +%F).sql | grep "MySQL dump"
```

## Jenkins CLI Commands (Optional)

### If Jenkins CLI is available
```bash
# Get Jenkins CLI
wget http://localhost:8080/jnlpJars/jenkins-cli.jar

# Build job manually
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:Adm!n321 build database-backup

# Get job status
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:Adm!n321 get-job database-backup

# Get last build console output
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:Adm!n321 console database-backup
```

## Complete Backup Process (Manual Test)

### Execute from Jump Host
```bash
# Full backup process in one command sequence
DB_HOST="stdb01"
DB_USER="kodekloud_roy"
DB_PASS="asdfgdsd"
DB_NAME="kodekloud_db01"
DB_USER_SSH="peter"
BACKUP_HOST="stbkp01"
BACKUP_USER="clint"
BACKUP_DIR="/home/clint/db_backups"
DUMP_FILE="db_$(date +%F).sql"

# Step 1: Create dump
ssh -o StrictHostKeyChecking=no ${DB_USER_SSH}@${DB_HOST} \
  "mysqldump -u ${DB_USER} -p${DB_PASS} ${DB_NAME} > /tmp/${DUMP_FILE}"

# Step 2: Copy to backup server
ssh -o StrictHostKeyChecking=no ${DB_USER_SSH}@${DB_HOST} \
  "scp -o StrictHostKeyChecking=no /tmp/${DUMP_FILE} ${BACKUP_USER}@${BACKUP_HOST}:${BACKUP_DIR}/"

# Step 3: Cleanup
ssh -o StrictHostKeyChecking=no ${DB_USER_SSH}@${DB_HOST} \
  "rm -f /tmp/${DUMP_FILE}"

# Step 4: Verify
ssh -o StrictHostKeyChecking=no ${BACKUP_USER}@${BACKUP_HOST} \
  "ls -lh ${BACKUP_DIR}/${DUMP_FILE}"
```

## Monitoring Commands

### Check Jenkins Job Status
```bash
# From Jenkins Console Output or via curl
curl -u admin:Adm!n321 http://localhost:8080/job/database-backup/lastBuild/api/json

# Check if job is running
curl -u admin:Adm!n321 http://localhost:8080/job/database-backup/lastBuild/api/json | grep building
```

### Monitor Disk Space
```bash
# On backup server
ssh clint@stbkp01 "df -h /home/clint/db_backups"

# Check backup directory size
ssh clint@stbkp01 "du -sh /home/clint/db_backups"
```

### Check Cron Schedule
```bash
# View Jenkins job configuration (if you have access to Jenkins home)
cat /var/lib/jenkins/jobs/database-backup/config.xml | grep -A 5 "triggers"
```

## Troubleshooting Commands

### Debug SSH Issues
```bash
# Test SSH with verbose output
ssh -v peter@stdb01

# Test SSH without known_hosts check
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null peter@stdb01

# Check SSH agent
ssh-add -l

# Add SSH key to agent
ssh-add ~/.ssh/id_ed25519
```

### Debug Database Issues
```bash
# Test database connection
ssh peter@stdb01 "mysql -u kodekloud_roy -pasdfgdsd -e 'SELECT 1'"

# Check MySQL status
ssh peter@stdb01 "systemctl status mysql"

# Check MySQL error logs
ssh peter@stdb01 "sudo tail -50 /var/log/mysql/error.log"
```

### Debug Backup Transfer Issues
```bash
# Test SCP between servers directly
ssh peter@stdb01 "echo 'test' > /tmp/test.txt && scp /tmp/test.txt clint@stbkp01:/tmp/"

# Check permissions
ssh clint@stbkp01 "ls -la /home/clint/db_backups"

# Check if directory is writable
ssh clint@stbkp01 "touch /home/clint/db_backups/test_write && rm /home/clint/db_backups/test_write"
```

### Jenkins Logs
```bash
# View Jenkins system log (if accessible)
tail -f /var/log/jenkins/jenkins.log

# Check Jenkins job workspace
ls -la /var/lib/jenkins/workspace/database-backup/
```

## Backup Restoration (Testing)

### Restore Database from Backup
```bash
# Copy backup to database server
ssh clint@stbkp01 "scp /home/clint/db_backups/db_$(date +%F).sql peter@stdb01:/tmp/"

# Restore database
ssh peter@stdb01 "mysql -u kodekloud_roy -pasdfgdsg kodekloud_db01 < /tmp/db_$(date +%F).sql"

# Verify restoration
ssh peter@stdb01 "mysql -u kodekloud_roy -pasdfgdsd kodekloud_db01 -e 'SHOW TABLES;'"
```

## Cleanup Commands

### Remove Old Backups
```bash
# Remove backups older than 7 days
ssh clint@stbkp01 "find /home/clint/db_backups -name 'db_*.sql' -mtime +7 -delete"

# List files to be deleted (dry run)
ssh clint@stbkp01 "find /home/clint/db_backups -name 'db_*.sql' -mtime +7"

# Keep only last 10 backups
ssh clint@stbkp01 "cd /home/clint/db_backups && ls -t db_*.sql | tail -n +11 | xargs rm -f"
```

## Date Format Commands

### Understanding the Date Format
```bash
# Current date in YYYY-MM-DD format
date +%F

# Examples of date formatting
date +%F        # 2025-11-22
date +%Y        # 2025
date +%m        # 11
date +%d        # 22
date +%Y%m%d    # 20251122
date +%F_%H%M   # 2025-11-22_0940
```

## Quick Reference

### File Locations
```bash
# SSH Keys (jumphost)
~/.ssh/id_ed25519           # Private key
~/.ssh/id_ed25519.pub       # Public key
~/.ssh/known_hosts          # Known hosts

# Database Server
/tmp/db_YYYY-MM-DD.sql     # Temporary dump location

# Backup Server
/home/clint/db_backups/    # Final backup location

# Jenkins (typical locations)
/var/lib/jenkins/          # Jenkins home
/var/log/jenkins/          # Jenkins logs
```

### Quick Health Check
```bash
# One-liner to check entire backup chain
echo "=== SSH Connections ===" && \
ssh peter@stdb01 "hostname" && \
ssh clint@stbkp01 "hostname" && \
echo "=== Database Access ===" && \
ssh peter@stdb01 "mysql -u kodekloud_roy -pasdfgdsd -e 'SELECT 1'" && \
echo "=== Backup Directory ===" && \
ssh clint@stbkp01 "ls -lh /home/clint/db_backups/ | tail -5" && \
echo "=== All checks passed ==="
```
