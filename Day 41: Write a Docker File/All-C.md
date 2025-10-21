## Docker Commands Reference for Nautilus Apache2 Container

### **Prerequisites**
```bash
# Verify Docker is installed and running
docker --version
docker info

# Check if user has docker privileges (or use sudo)
docker ps
```

---

## **Dockerfile Setup Commands**

### **1. Create Directory Structure**
```bash
# Create the docker directory
sudo mkdir -p /opt/docker
cd /opt/docker

# Verify directory creation
pwd
ls -la
```

### **2. Create Dockerfile**
```bash
# Create the Dockerfile (capital D as required)
sudo nano Dockerfile

# Alternative: Use cat to create file
sudo cat > Dockerfile << 'EOF'
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    apache2 \
    && rm -rf /var/lib/apt/lists/*
RUN sed -i 's/Listen 80/Listen 8087/g' /etc/apache2/ports.conf
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8087>/g' /etc/apache2/sites-available/000-default.conf
RUN echo '<html><body><h1>Apache2 on Ubuntu 24.04 - Port 8087</h1><p>Server is running successfully!</p></body></html>' > /var/www/html/index.html
EXPOSE 8087
CMD ["apache2ctl", "-D", "FOREGROUND"]
EOF
```

### **3. Verify Dockerfile**
```bash
# Check file permissions and content
ls -la Dockerfile
cat Dockerfile

# Check for syntax errors
dockerfile_lint Dockerfile 2>/dev/null || echo "Dockerfile lint not available, proceeding..."
```

---

## **Docker Image Build Commands**

### **4. Build Docker Image**
```bash
# Build image with tag
sudo docker build -t nautilus-apache:8087 .

# Build with specific name and version
sudo docker build -t nautilus-apache:v1.0 .

# Build with no cache (clean build)
sudo docker build --no-cache -t nautilus-apache:8087 .

# Build with custom build arguments
sudo docker build --build-arg HTTP_PROXY=$http_proxy -t nautilus-apache:8087 .
```

### **5. Verify Image Build**
```bash
# List all images
sudo docker images

# List specific image
sudo docker images | grep nautilus-apache

# Show detailed image information
sudo docker image inspect nautilus-apache:8087

# Check image history
sudo docker history nautilus-apache:8087
```

---

## **Docker Container Management Commands**

### **6. Run Container**
```bash
# Basic run (detached mode)
sudo docker run -d --name nautilus-apache-container nautilus-apache:8087

# Run with port mapping
sudo docker run -d -p 8087:8087 --name nautilus-apache-container nautilus-apache:8087

# Run with custom container name and restart policy
sudo docker run -d -p 8087:8087 --name nautilus-apache-container --restart=always nautilus-apache:8087

# Run with volume mapping for persistent data
sudo docker run -d -p 8087:8087 --name nautilus-apache-container -v /opt/apache-data:/var/www/html nautilus-apache:8087

# Run with environment variables
sudo docker run -d -p 8087:8087 --name nautilus-apache-container -e APACHE_LOG_LEVEL=info nautilus-apache:8087

# Run with resource limits
sudo docker run -d -p 8087:8087 --name nautilus-apache-container --memory=512m --cpus=0.5 nautilus-apache:8087
```

### **7. Container Lifecycle Commands**
```bash
# Start container
sudo docker start nautilus-apache-container

# Stop container gracefully
sudo docker stop nautilus-apache-container

# Force stop container
sudo docker kill nautilus-apache-container

# Restart container
sudo docker restart nautilus-apache-container

# Pause container
sudo docker pause nautilus-apache-container

# Unpause container
sudo docker unpause nautilus-apache-container

# Remove container (must be stopped first)
sudo docker rm nautilus-apache-container

# Force remove running container
sudo docker rm -f nautilus-apache-container
```

---

## **Container Monitoring and Debugging Commands**

### **8. Container Status and Logs**
```bash
# List running containers
sudo docker ps

# List all containers (including stopped)
sudo docker ps -a

# Show container logs
sudo docker logs nautilus-apache-container

# Follow log output in real-time
sudo docker logs -f nautilus-apache-container

# Show last 50 lines of logs
sudo docker logs --tail 50 nautilus-apache-container

# Show logs with timestamps
sudo docker logs -t nautilus-apache-container

# Show logs since specific time
sudo docker logs --since 2h nautilus-apache-container
```

### **9. Container Inspection**
```bash
# Show container details
sudo docker inspect nautilus-apache-container

# Show container processes
sudo docker top nautilus-apache-container

# Show container resource usage
sudo docker stats nautilus-apache-container

# Show container port mappings
sudo docker port nautilus-apache-container

# Show container IP address
sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nautilus-apache-container
```

### **10. Interactive Container Access**
```bash
# Execute bash shell in running container
sudo docker exec -it nautilus-apache-container bash

# Execute single command
sudo docker exec nautilus-apache-container apache2ctl status

# Execute as root user
sudo docker exec -u 0 -it nautilus-apache-container bash

# Copy files from container to host
sudo docker cp nautilus-apache-container:/var/log/apache2/error.log /tmp/

# Copy files from host to container
sudo docker cp /tmp/local-file.txt nautilus-apache-container:/var/www/html/
```

---

## **Apache2 Service Verification Commands**

### **11. Test Apache2 Configuration**
```bash
# Test from inside container
sudo docker exec nautilus-apache-container apache2ctl configtest

# Check Apache2 service status
sudo docker exec nautilus-apache-container service apache2 status

# Check if Apache2 is listening on correct port
sudo docker exec nautilus-apache-container netstat -tlnp | grep 8087

# Alternative: ss command
sudo docker exec nautilus-apache-container ss -tlnp | grep 8087
```

### **12. Test Web Server from Host**
```bash
# Test local connection
curl http://localhost:8087

# Test with headers
curl -I http://localhost:8087

# Test with verbose output
curl -v http://localhost:8087

# Test from another container on same network
sudo docker run --rm --network container:nautilus-apache-container appropriate/curl curl http://localhost:8087

# Test with external IP
EXTERNAL_IP=$(hostname -I | awk '{print $1}')
curl http://$EXTERNAL_IP:8087
```

---

## **Network and Connectivity Commands**

### **13. Network Configuration**
```bash
# List networks
sudo docker network ls

# Create custom network
sudo docker network create nautilus-network

# Run container on custom network
sudo docker run -d -p 8087:8087 --name nautilus-apache-container --network nautilus-network nautilus-apache:8087

# Inspect network
sudo docker network inspect nautilus-network

# Connect existing container to network
sudo docker network connect nautilus-network nautilus-apache-container

# Disconnect from network
sudo docker network disconnect nautilus-network nautilus-apache-container
```

---

## **Cleanup and Maintenance Commands**

### **14. System Cleanup**
```bash
# Remove unused containers
sudo docker container prune

# Remove unused images
sudo docker image prune

# Remove unused networks
sudo docker network prune

# Remove unused volumes
sudo docker volume prune

# Remove everything unused (aggressive cleanup)
sudo docker system prune

# Remove everything including unused images
sudo docker system prune -a

# Remove specific image
sudo docker rmi nautilus-apache:8087

# Force remove image
sudo docker rmi -f nautilus-apache:8087
```

---

## **Advanced Commands and Troubleshooting**

### **15. Debugging Commands**
```bash
# Check container resource limits
sudo docker exec nautilus-apache-container cat /proc/1/limits

# Check container memory usage
sudo docker exec nautilus-apache-container free -m

# Check disk usage
sudo docker exec nautilus-apache-container df -h

# Check Apache2 error logs
sudo docker exec nautilus-apache-container tail -f /var/log/apache2/error.log

# Check Apache2 access logs
sudo docker exec nautilus-apache-container tail -f /var/log/apache2/access.log

# Monitor container in real-time
sudo docker attach nautilus-apache-container

# Detach from container (without stopping)
# Press Ctrl+P followed by Ctrl+Q
```

### **16. Performance Monitoring**
```bash
# Real-time container stats
sudo docker stats nautilus-apache-container

# Show container changes
sudo docker diff nautilus-apache-container

# Export container filesystem
sudo docker export nautilus-apache-container > nautilus-apache-filesystem.tar

# Create snapshot of running container
sudo docker commit nautilus-apache-container nautilus-apache-snapshot:$(date +%Y%m%d)
```

---

## **Automation and Scripting**

### **17. Quick Setup Script**
```bash
#!/bin/bash
# save as setup-nautilus-apache.sh

echo "Setting up Nautilus Apache2 Docker container..."

# Build image
sudo docker build -t nautilus-apache:8087 .

# Stop and remove existing container if exists
sudo docker stop nautilus-apache-container 2>/dev/null
sudo docker rm nautilus-apache-container 2>/dev/null

# Run new container
sudo docker run -d -p 8087:8087 --name nautilus-apache-container --restart=always nautilus-apache:8087

# Wait for container to start
sleep 5

# Test the web server
if curl -s http://localhost:8087 > /dev/null; then
    echo "✅ Apache2 is running successfully on port 8087"
else
    echo "❌ Apache2 test failed. Check logs:"
    sudo docker logs nautilus-apache-container
fi

# Show container status
sudo docker ps | grep nautilus-apache-container
```

### **18. Make script executable and run**
```bash
chmod +x setup-nautilus-apache.sh
./setup-nautilus-apache.sh
```

---

## **Security and Best Practices**

### **19. Security Commands**
```bash
# Scan image for vulnerabilities (if Docker Scout available)
sudo docker scout cves nautilus-apache:8087

# Check image history for security issues
sudo docker history --no-trunc nautilus-apache:8087

# Run container with read-only root filesystem
sudo docker run -d -p 8087:8087 --name nautilus-apache-container --read-only nautilus-apache:8087

# Run with specific user (non-root)
sudo docker run -d -p 8087:8087 --name nautilus-apache-container --user 1000:1000 nautilus-apache:8087

# Limit container capabilities
sudo docker run -d -p 8087:8087 --name nautilus-apache-container --cap-drop=ALL --cap-add=NET_BIND_SERVICE nautilus-apache:8087
```

---

## **Useful Aliases**

### **20. Docker Aliases for Convenience**
```bash
# Add to ~/.bashrc or ~/.bash_aliases
echo "
# Docker aliases
alias dps='sudo docker ps'
alias dpsa='sudo docker ps -a'
alias dlogs='sudo docker logs'
alias dexec='sudo docker exec -it'
alias dstop='sudo docker stop'
alias drm='sudo docker rm'
alias drmi='sudo docker rmi'
alias dbuild='sudo docker build'
alias drun='sudo docker run'
alias dstats='sudo docker stats'
alias dinspect='sudo docker inspect'
" >> ~/.bashrc

# Reload bash configuration
source ~/.bashrc
```

---

## **Quick Reference**

| Command | Description |
|---------|-------------|
| `sudo docker build -t nautilus-apache:8087 .` | Build the Docker image |
| `sudo docker run -d -p 8087:8087 --name nautilus-apache-container nautilus-apache:8087` | Run container with port mapping |
| `sudo docker ps` | List running containers |
| `sudo docker logs nautilus-apache-container` | View container logs |
| `curl http://localhost:8087` | Test Apache2 web server |
| `sudo docker exec -it nautilus-apache-container bash` | Access container shell |
| `sudo docker stop nautilus-apache-container` | Stop container |
| `sudo docker rm nautilus-apache-container` | Remove container |
| `sudo docker rmi nautilus-apache:8087` | Remove image |

---

## **Troubleshooting Checklist**

1. **Container won't start**: Check logs with `sudo docker logs nautilus-apache-container`
2. **Port 8087 not accessible**: Verify port mapping and firewall settings
3. **Apache2 not responding**: Check if Apache2 is running inside container
4. **Permission denied**: Use `sudo` for Docker commands or add user to docker group
5. **Image build fails**: Check Dockerfile syntax and network connectivity
6. **Container exits immediately**: Check CMD instruction in Dockerfile

---

**Note**: Replace `nautilus-apache-container` with your preferred container name and adjust paths as needed for your specific environment.
