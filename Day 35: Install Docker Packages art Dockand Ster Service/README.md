# Docker CE and Docker Compose Installation Guide

## Project Overview

This document provides comprehensive instructions for installing Docker CE and Docker Compose on App Server 1 as part of the Nautilus DevOps containerization initiative.

## Prerequisites

- **Operating System**: CentOS/RHEL 7/8 or compatible Linux distribution
- **User Privileges**: Root or sudo access
- **Network**: Internet connectivity for downloading packages
- **Server**: App Server 1

## Table of Contents

1. [Installation Steps](#installation-steps)
2. [Verification](#verification)
3. [Post-Installation Configuration](#post-installation-configuration)
4. [Troubleshooting](#troubleshooting)
5. [Usage Examples](#usage-examples)
6. [Additional Resources](#additional-resources)

---

## Installation Steps

### Step 1: Update System Packages

```bash
sudo yum update -y
```

### Step 2: Install Required Dependencies

```bash
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

### Step 3: Add Docker Repository

```bash
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

### Step 4: Install Docker CE

```bash
sudo yum install -y docker-ce docker-ce-cli containerd.io
```

### Step 5: Install Docker Compose

```bash
# Download the latest stable release
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make it executable
sudo chmod +x /usr/local/bin/docker-compose

# Optional: Create symbolic link
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

### Step 6: Start Docker Service

```bash
# Start Docker
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker
```

---

## Verification

Run the following commands to verify successful installation:

```bash
# Check Docker version
docker --version

# Check Docker Compose version
docker-compose --version

# Verify Docker service status
sudo systemctl status docker

# Test Docker with hello-world image
sudo docker run hello-world
```

**Expected Output:**
- Docker version: `Docker version 24.x.x` or higher
- Docker Compose version: `Docker Compose version v2.x.x` or higher
- Service status: `Active: active (running)`

---

## Post-Installation Configuration

### Add User to Docker Group (Optional)

To run Docker commands without `sudo`:

```bash
# Add current user to docker group
sudo usermod -aG docker $USER

# Apply changes
newgrp docker

# Or logout and login again for changes to take effect
```

### Configure Docker to Start on Boot

```bash
sudo systemctl enable docker
```

### Test Non-Root Access

```bash
docker ps
docker images
```

---

## Troubleshooting

### Issue 1: Docker Service Won't Start

**Solution:**
```bash
# Check service logs
sudo journalctl -u docker.service

# Restart the service
sudo systemctl restart docker
```

### Issue 2: Permission Denied Error

**Solution:**
```bash
# Ensure you're in the docker group
groups $USER

# If not, add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

### Issue 3: Docker Compose Command Not Found

**Solution:**
```bash
# Check if binary exists
ls -l /usr/local/bin/docker-compose

# If missing, reinstall
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Issue 4: Repository Connection Issues

**Solution:**
```bash
# Clear yum cache
sudo yum clean all

# Retry repository addition
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

---

## Usage Examples

### Basic Docker Commands

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# List images
docker images

# Pull an image
docker pull nginx:latest

# Run a container
docker run -d -p 80:80 nginx:latest

# Stop a container
docker stop <container_id>

# Remove a container
docker rm <container_id>
```

### Basic Docker Compose Commands

```bash
# Start services defined in docker-compose.yml
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs

# List services
docker-compose ps

# Build images
docker-compose build
```

### Sample docker-compose.yml

```yaml
version: '3.8'

services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html
    restart: unless-stopped

  app:
    image: node:18-alpine
    working_dir: /app
    volumes:
      - ./app:/app
    command: npm start
    depends_on:
      - web
```

---

## Additional Resources

### Official Documentation

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/)

### Useful Commands Reference

```bash
# System information
docker info
docker version

# Clean up unused resources
docker system prune -a

# View resource usage
docker stats

# Inspect container
docker inspect <container_id>

# Execute command in running container
docker exec -it <container_id> /bin/bash
```

---

## Support and Maintenance

### Regular Maintenance Tasks

1. **Update Docker packages** periodically:
   ```bash
   sudo yum update docker-ce docker-ce-cli containerd.io
   ```

2. **Clean up unused images and containers**:
   ```bash
   docker system prune -a --volumes
   ```

3. **Monitor Docker service**:
   ```bash
   sudo systemctl status docker
   ```

### Contact Information

For issues or questions regarding this setup:
- **Team**: Nautilus DevOps Team
- **Server**: App Server 1
- **Documentation Date**: October 2025

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | October 2025 | Initial installation guide |

---

## License

This documentation is intended for internal use by the Nautilus DevOps team.

---

**End of Document**
