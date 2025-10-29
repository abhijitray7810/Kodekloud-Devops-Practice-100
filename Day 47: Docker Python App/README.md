# Python Application - Docker Deployment Guide

## Overview
This guide provides step-by-step instructions to Dockerize and deploy a Python application on App Server 1 using Docker containers.

## Prerequisites
- Docker installed on App Server 1
- Access to App Server 1 with sudo privileges
- Python application files located in `/python_app/src/`

## Project Structure
```
/python_app/
├── Dockerfile
└── src/
    ├── requirements.txt
    └── server.py
```

## Deployment Steps

### Step 1: Create the Dockerfile
Navigate to the `/python_app` directory and create the Dockerfile:

```bash
cd /python_app
sudo vi Dockerfile
```

Add the following content:

```dockerfile
# Use Python base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements file
COPY src/requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY src/ .

# Expose port 5001
EXPOSE 5001

# Run the application
CMD ["python", "server.py"]
```

### Step 2: Build the Docker Image
Build the Docker image with the tag `nautilus/python-app`:

```bash
cd /python_app
docker build -t nautilus/python-app .
```

**Expected Output:**
```
Successfully built <image-id>
Successfully tagged nautilus/python-app:latest
```

### Step 3: Run the Container
Create and start a container named `pythonapp_nautilus` with port mapping:

```bash
docker run -d --name pythonapp_nautilus -p 8092:5001 nautilus/python-app
```

**Port Mapping:**
- Container Port: `5001`
- Host Port: `8092`

### Step 4: Test the Application
Test the deployed application using curl:

```bash
curl http://localhost:8092/
```

## Useful Docker Commands

### Container Management
```bash
# Check running containers
docker ps

# Check all containers (including stopped)
docker ps -a

# View container logs
docker logs pythonapp_nautilus

# Follow container logs in real-time
docker logs -f pythonapp_nautilus

# Stop the container
docker stop pythonapp_nautilus

# Start the container
docker start pythonapp_nautilus

# Restart the container
docker restart pythonapp_nautilus

# Remove the container (must be stopped first)
docker rm pythonapp_nautilus

# Force remove running container
docker rm -f pythonapp_nautilus
```

### Image Management
```bash
# List all images
docker images

# Remove the image
docker rmi nautilus/python-app

# View image details
docker inspect nautilus/python-app

# View image history
docker history nautilus/python-app
```

### Debugging
```bash
# Execute commands inside the running container
docker exec -it pythonapp_nautilus bash

# Check container resource usage
docker stats pythonapp_nautilus

# Inspect container details
docker inspect pythonapp_nautilus
```

## Troubleshooting

### Issue: Build fails with "no such file or directory"
**Cause:** Dockerfile is in the wrong location

**Solution:** Ensure Dockerfile is in `/python_app/` directory, not in `/python_app/src/`

```bash
# If Dockerfile is in src directory, move it:
sudo mv /python_app/src/Dockerfile /python_app/
cd /python_app
docker build -t nautilus/python-app .
```

### Issue: Port already in use
**Error:** `bind: address already in use`

**Solution:** Check if port 8092 is already in use:
```bash
# Check what's using port 8092
sudo netstat -tulpn | grep 8092
# or
sudo lsof -i :8092

# Stop the conflicting service or use a different port
```

### Issue: Container exits immediately
**Solution:** Check container logs:
```bash
docker logs pythonapp_nautilus
```

### Issue: Cannot connect to application
**Solution:** Verify container is running and port mapping is correct:
```bash
docker ps | grep pythonapp_nautilus
curl http://localhost:8092/
```

## Clean Up

To completely remove the deployment:

```bash
# Stop and remove container
docker stop pythonapp_nautilus
docker rm pythonapp_nautilus

# Remove image
docker rmi nautilus/python-app

# Remove all unused Docker resources (optional)
docker system prune -a
```

## Configuration Details

### Base Image
- **Image:** `python:3.9-slim`
- **Benefits:** Lightweight, contains essential Python runtime

### Application Configuration
- **Application Port:** 5001 (internal)
- **Host Port:** 8092 (external)
- **Container Name:** pythonapp_nautilus
- **Image Name:** nautilus/python-app

### Dependencies
All Python dependencies are listed in `requirements.txt` and automatically installed during the Docker image build process.

## Security Notes

- The application runs as root inside the container (default behavior)
- For production deployments, consider creating a non-root user
- Review and update dependencies regularly
- Use specific Python version tags instead of `latest` for reproducibility

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Python Docker Best Practices](https://docs.docker.com/language/python/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)

## Support

For issues or questions related to this deployment, please contact the infrastructure team.

---

**Last Updated:** October 29, 2025  
**Maintained By:** DevOps Team  
**Application:** Nautilus Python App
