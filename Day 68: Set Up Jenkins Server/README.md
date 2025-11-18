# Jenkins Server Setup Guide

## Overview
This guide provides step-by-step instructions for installing and configuring Jenkins on the xFusionCorp Industries server for CI/CD pipeline implementation.

## Environment Details

### Server Information
- **Server Name:** jenkins
- **Access Method:** SSH from jump host
- **Username:** root
- **Password:** S3curePass

### Admin User Configuration
- **Username:** theadmin
- **Password:** Adm!n321
- **Full Name:** Javed
- **Email:** javed@jenkins.stratos.xfusioncorp.com

## Prerequisites
- Access to jump host
- Root privileges on jenkins server
- Internet connectivity for package downloads

## Installation Steps

### 1. Connect to Jenkins Server
```bash
ssh root@jenkins
# Enter password: S3curePass
```

### 2. Add Jenkins Repository
```bash
# Download Jenkins repository configuration
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import Jenkins GPG key for package verification
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
```

### 3. Install Required Dependencies
```bash
# Update system packages
sudo yum upgrade -y

# Install Java 17 (required for Jenkins)
sudo yum install fontconfig java-17-openjdk -y

# Verify Java installation
java -version
```

### 4. Install Jenkins
```bash
# Install Jenkins using yum
sudo yum install jenkins -y
```

### 5. Start Jenkins Service
```bash
# Start the Jenkins service
sudo systemctl start jenkins

# Enable Jenkins to start automatically on boot
sudo systemctl enable jenkins

# Verify Jenkins is running
sudo systemctl status jenkins
```

### 6. Retrieve Initial Admin Password
```bash
# Display the initial administrator password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
**Important:** Copy this password - you'll need it for web UI setup.

### 7. Access Jenkins Web UI
1. Click the **Jenkins** button on the top bar of your interface
2. Paste the initial admin password when prompted
3. Click "Continue"

### 8. Install Plugins
1. Select "Install suggested plugins" (recommended for standard setup)
2. Wait for plugin installation to complete (this may take a few minutes)

### 9. Create Admin User
When prompted to create the first admin user, enter the following details:

| Field | Value |
|-------|-------|
| Username | theadmin |
| Password | Adm!n321 |
| Confirm Password | Adm!n321 |
| Full Name | Javed |
| Email Address | javed@jenkins.stratos.xfusioncorp.com |

Click **Save and Continue**

### 10. Configure Instance
1. Keep the default Jenkins URL or modify as needed
2. Click **Save and Finish**
3. Click **Start using Jenkins**

## Verification

### Verify Installation
```bash
# Check Jenkins service status
sudo systemctl status jenkins

# Check if Jenkins is listening on port 8080
sudo netstat -tulpn | grep 8080

# View Jenkins logs
sudo tail -f /var/log/jenkins/jenkins.log
```

### Verify Admin User
1. Log out from Jenkins UI
2. Log back in using:
   - Username: `theadmin`
   - Password: `Adm!n321`
3. Confirm that "Javed" appears in the top right corner

## Troubleshooting

### Service Fails to Start
If Jenkins service fails to start or times out:

```bash
# Check detailed service status
sudo systemctl status jenkins -l

# View recent logs
sudo journalctl -u jenkins -n 50

# Check for port conflicts
sudo lsof -i :8080
```

### Common Issues and Solutions

#### Port 8080 Already in Use
```bash
# Find process using port 8080
sudo lsof -i :8080

# Kill the process (replace PID with actual process ID)
sudo kill -9 <PID>

# Restart Jenkins
sudo systemctl restart jenkins
```

#### Insufficient Memory
```bash
# Check available memory
free -h

# If needed, adjust Jenkins memory settings
sudo vi /etc/sysconfig/jenkins
# Modify JENKINS_JAVA_OPTIONS to adjust heap size
```

#### Firewall Issues
```bash
# Check firewall status
sudo systemctl status firewalld

# If firewall is active, allow port 8080
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

#### Java Not Found
```bash
# Verify Java installation
which java
java -version

# If not installed, reinstall Java
sudo yum install java-17-openjdk -y
```

## Important File Locations

| Description | Path |
|-------------|------|
| Jenkins Home Directory | /var/lib/jenkins |
| Configuration File | /etc/sysconfig/jenkins |
| Log Files | /var/log/jenkins/jenkins.log |
| Initial Admin Password | /var/lib/jenkins/secrets/initialAdminPassword |
| Repository Configuration | /etc/yum.repos.d/jenkins.repo |

## Post-Installation Tasks

### Recommended Next Steps
1. Configure additional security settings
2. Set up backup strategy for Jenkins configuration
3. Install additional plugins based on project requirements
4. Configure build agents/nodes if needed
5. Set up project-specific pipelines
6. Configure email notifications
7. Integrate with version control systems (Git, GitHub, GitLab, etc.)

### Security Best Practices
- Change default admin password regularly
- Enable CSRF protection
- Configure authentication and authorization
- Set up SSL/TLS certificates
- Regular security updates
- Implement role-based access control (RBAC)

## Useful Commands

```bash
# Start Jenkins
sudo systemctl start jenkins

# Stop Jenkins
sudo systemctl stop jenkins

# Restart Jenkins
sudo systemctl restart jenkins

# Check Jenkins status
sudo systemctl status jenkins

# View real-time logs
sudo tail -f /var/log/jenkins/jenkins.log

# View Jenkins version
rpm -qa | grep jenkins
```

## Support and Documentation

- **Official Jenkins Documentation:** https://www.jenkins.io/doc/
- **Jenkins User Guide:** https://www.jenkins.io/doc/book/
- **Plugin Index:** https://plugins.jenkins.io/
- **Community Forums:** https://community.jenkins.io/

## Notes

- Jenkins runs on port 8080 by default
- The installation uses the stable release channel
- Java 17 is required for recent Jenkins versions
- Initial setup requires the auto-generated admin password
- All commands should be executed with root privileges

## Version Information

- **Jenkins:** Latest stable version from RedHat repository
- **Java:** OpenJDK 17
- **Installation Method:** YUM package manager

---

**Document Version:** 1.0  
**Last Updated:** November 2025  
**Maintained by:** xFusionCorp Industries DevOps Team
