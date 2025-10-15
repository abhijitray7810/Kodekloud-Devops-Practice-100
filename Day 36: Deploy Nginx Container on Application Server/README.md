# Nginx Container Deployment on Application Server 1

## Overview
This document provides instructions for deploying an nginx container on Application Server 1 as part of the Nautilus DevOps team's application deployment tests.

## Prerequisites
- SSH access to Application Server 1
- Docker installed and running on Application Server 1
- Appropriate permissions to run Docker commands (sudo/root or user in docker group)

## Deployment Requirements
- **Container Name:** `nginx_1`
- **Image:** `nginx:alpine`
- **State:** Running

## Deployment Steps

### 1. Connect to Application Server 1
```bash
ssh user@application-server-1
```
Replace `user` with your actual username and `application-server-1` with the correct hostname or IP address.

### 2. Pull the Nginx Alpine Image (Optional)
```bash
docker pull nginx:alpine
```
This step ensures you have the latest version of the nginx alpine image.

### 3. Create and Run the Container
```bash
docker run -d --name nginx_1 nginx:alpine
```

**Command Breakdown:**
- `-d` - Run container in detached mode (background)
- `--name nginx_1` - Assign the name "nginx_1" to the container
- `nginx:alpine` - Use the nginx image with alpine tag

### 4. Verify Container Status
```bash
docker ps
```

Expected output should show the `nginx_1` container with "Up" status.

#### Alternative Verification Commands
```bash
# Check specific container
docker ps -f name=nginx_1

# Detailed status check
docker inspect nginx_1 | grep -i status

# Formatted output
docker ps --filter name=nginx_1 --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
```

## Container Management

### Start the Container
```bash
docker start nginx_1
```

### Stop the Container
```bash
docker stop nginx_1
```

### Restart the Container
```bash
docker restart nginx_1
```

### View Container Logs
```bash
docker logs nginx_1

# Follow logs in real-time
docker logs -f nginx_1
```

### Remove the Container
```bash
# Stop first
docker stop nginx_1

# Remove
docker rm nginx_1
```

## Troubleshooting

### Container Not Starting
1. Check if the container exists:
   ```bash
   docker ps -a | grep nginx_1
   ```

2. View container logs for errors:
   ```bash
   docker logs nginx_1
   ```

3. Check Docker daemon status:
   ```bash
   sudo systemctl status docker
   ```

### Port Conflicts
If you need to expose ports and encounter conflicts:
```bash
# Check what's using port 80
sudo netstat -tulpn | grep :80

# Run container with custom port mapping
docker run -d --name nginx_1 -p 8080:80 nginx:alpine
```

### Permission Denied
If you encounter permission issues:
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again, or use
newgrp docker
```

## Testing the Deployment

### Check Container Health
```bash
# Access nginx welcome page from within the server
curl http://localhost:80

# Or if you mapped ports
curl http://localhost:8080
```

### Execute Commands Inside Container
```bash
docker exec -it nginx_1 sh
```

## Container Information

### View Container Details
```bash
docker inspect nginx_1
```

### View Resource Usage
```bash
docker stats nginx_1
```

## Best Practices
- Always use specific image tags (like `alpine`) instead of `latest` for production
- Monitor container logs regularly
- Implement health checks for production deployments
- Use Docker Compose for multi-container applications
- Backup container configurations and data volumes

## Additional Resources
- [Official Nginx Docker Image](https://hub.docker.com/_/nginx)
- [Docker Documentation](https://docs.docker.com/)
- [Nginx Documentation](https://nginx.org/en/docs/)

## Support
For issues or questions, contact the Nautilus DevOps team.

---
**Last Updated:** October 2025  
**Maintained By:** Nautilus DevOps Team
