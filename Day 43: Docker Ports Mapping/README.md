# Nginx Container Setup - Application Server 1

## Overview
This document provides instructions for deploying an nginx-based container on Application Server 1 in the Stratos Datacenter using the `nginx:alpine-perl` Docker image.

## Prerequisites
- Access to Application Server 1 in Stratos Datacenter
- Docker installed and running on the server
- Sufficient privileges (sudo access) to execute Docker commands
- Port 8083 available on the host machine

## Task Requirements
- **Image**: `nginx:alpine-perl`
- **Container Name**: `cluster`
- **Port Mapping**: Host port `8083` → Container port `80`
- **State**: Running

## Installation Steps

### Step 1: Connect to Application Server 1
```bash
ssh <username>@<application_server_1_hostname>
```

### Step 2: Pull the Docker Image
Pull the nginx:alpine-perl image from Docker Hub:
```bash
sudo docker pull nginx:alpine-perl
```

### Step 3: Verify Image Download
Confirm the image has been downloaded successfully:
```bash
sudo docker images | grep nginx
```

Expected output should include:
```
nginx    alpine-perl    <image_id>    <created>    <size>
```

### Step 4: Create and Run the Container
Create a container named "cluster" with port mapping:
```bash
sudo docker run -d --name cluster -p 8083:80 nginx:alpine-perl
```

**Command Breakdown:**
- `-d`: Run in detached mode (background)
- `--name cluster`: Assign the name "cluster" to the container
- `-p 8083:80`: Map host port 8083 to container port 80
- `nginx:alpine-perl`: Use the nginx:alpine-perl image

### Step 5: Verify Container Status
Check that the container is running:
```bash
sudo docker ps
```

Expected output:
```
CONTAINER ID   IMAGE              COMMAND                  CREATED          STATUS          PORTS                  NAMES
<container_id> nginx:alpine-perl  "/docker-entrypoint.…"   <time>           Up <time>       0.0.0.0:8083->80/tcp   cluster
```

### Step 6: Test the Nginx Server
Test the nginx server is responding:
```bash
curl http://localhost:8083
```

You should receive the default nginx welcome page HTML.

## Container Management Commands

### Check Container Status
```bash
sudo docker ps -a
```

### View Container Logs
```bash
sudo docker logs cluster
```

### Stop the Container
```bash
sudo docker stop cluster
```

### Start the Container
```bash
sudo docker start cluster
```

### Restart the Container
```bash
sudo docker restart cluster
```

### Remove the Container
```bash
sudo docker stop cluster
sudo docker rm cluster
```

### Remove the Image
```bash
sudo docker rmi nginx:alpine-perl
```

## Troubleshooting

### Container Won't Start
Check if port 8083 is already in use:
```bash
sudo netstat -tulpn | grep 8083
# or
sudo lsof -i :8083
```

### Container Exited Unexpectedly
View container logs:
```bash
sudo docker logs cluster
```

### Permission Denied Errors
Ensure you're using `sudo` with Docker commands or your user is in the docker group:
```bash
sudo usermod -aG docker $USER
```
(Logout and login again for changes to take effect)

### Port Already in Use
If port 8083 is occupied, either:
1. Stop the service using port 8083
2. Use a different host port (update the `-p` flag accordingly)

## Verification Checklist
- [ ] Docker image `nginx:alpine-perl` pulled successfully
- [ ] Container named `cluster` created
- [ ] Port mapping configured: `8083:80`
- [ ] Container is in running state
- [ ] Nginx responds on `http://localhost:8083`

## Additional Information

### Image Details
- **Base**: Alpine Linux (lightweight)
- **Web Server**: Nginx
- **Additional**: Perl support included

### Security Considerations
- Ensure firewall rules allow traffic on port 8083 if accessing from external networks
- Consider implementing SSL/TLS for production environments
- Regularly update the image for security patches

### Network Access
To access the nginx server from outside the Application Server:
```
http://<application_server_1_ip>:8083
```

## Support
For issues or questions related to this deployment, contact the Nautilus DevOps team.

---

**Document Version**: 1.0  
**Last Updated**: October 28, 2025  
**Maintained By**: Nautilus DevOps Team
