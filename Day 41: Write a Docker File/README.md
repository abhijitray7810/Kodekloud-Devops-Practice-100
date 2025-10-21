# Nautilus Apache Docker Application

This repository contains the Dockerfile configuration for the Nautilus application development team's custom Apache web server image.

## Overview

This Docker image is built on Ubuntu 24.04 and includes Apache2 web server configured to run on port 8087. The image is designed for the Nautilus project deployment on App Server 1 in Stratos DC.

## Specifications

- **Base Image**: ubuntu:24.04
- **Web Server**: Apache2
- **Port**: 8087
- **Document Root**: Default Apache configuration (/var/www/html)

## Prerequisites

- Docker installed on App Server 1
- Sudo or root access to create directories and build images
- Network access to pull Ubuntu base image from Docker Hub

## Installation Steps

### 1. Create the Dockerfile Directory

```bash
sudo mkdir -p /opt/docker
cd /opt/docker
```

### 2. Create the Dockerfile

Create a file named `Dockerfile` (with capital D) in `/opt/docker/` directory with the provided configuration.

### 3. Build the Docker Image

```bash
sudo docker build -t nautilus-apache:latest /opt/docker/
```

**Alternative with custom tag:**
```bash
sudo docker build -t nautilus-apache:v1.0 /opt/docker/
```

### 4. Verify the Image

```bash
sudo docker images | grep nautilus-apache
```

## Usage

### Run a Container

**Basic run command:**
```bash
sudo docker run -d -p 8087:8087 --name nautilus-app nautilus-apache:latest
```

**Run with custom name:**
```bash
sudo docker run -d -p 8087:8087 --name my-nautilus-app nautilus-apache:latest
```

**Run with volume mount (for custom web content):**
```bash
sudo docker run -d -p 8087:8087 \
  -v /path/to/your/content:/var/www/html \
  --name nautilus-app \
  nautilus-apache:latest
```

### Verify the Container is Running

```bash
sudo docker ps | grep nautilus-apache
```

### Test the Apache Server

```bash
curl http://localhost:8087
```

Or from another machine:
```bash
curl http://<app-server-1-ip>:8087
```

## Container Management

### View Container Logs

```bash
sudo docker logs nautilus-app
```

**Follow logs in real-time:**
```bash
sudo docker logs -f nautilus-app
```

### Stop the Container

```bash
sudo docker stop nautilus-app
```

### Start the Container

```bash
sudo docker start nautilus-app
```

### Restart the Container

```bash
sudo docker restart nautilus-app
```

### Remove the Container

```bash
sudo docker rm -f nautilus-app
```

### Execute Commands Inside the Container

```bash
sudo docker exec -it nautilus-app bash
```

## Configuration Details

### Apache Configuration Files

- **Ports Configuration**: `/etc/apache2/ports.conf` - Modified to listen on port 8087
- **Default Virtual Host**: `/etc/apache2/sites-available/000-default.conf` - Updated to serve on port 8087
- **Document Root**: `/var/www/html` (unchanged from default)

### Environment Variables

- `DEBIAN_FRONTEND=noninteractive` - Set to avoid interactive prompts during package installation

## Troubleshooting

### Port Already in Use

If port 8087 is already in use, you can either:

1. Stop the service using the port
2. Use a different host port mapping:
   ```bash
   sudo docker run -d -p 8088:8087 --name nautilus-app nautilus-apache:latest
   ```

### Container Won't Start

Check the logs:
```bash
sudo docker logs nautilus-app
```

### Build Fails

Ensure you have:
- Internet connectivity to download packages
- Sufficient disk space
- Proper permissions (use sudo)

### Cannot Access from Browser

Check:
- Firewall rules allow traffic on port 8087
- Container is running: `sudo docker ps`
- Apache is listening: `sudo docker exec nautilus-app netstat -tlnp | grep 8087`

## Image Information

### Image Size

Check the built image size:
```bash
sudo docker images nautilus-apache:latest
```

### Image Layers

View image history:
```bash
sudo docker history nautilus-apache:latest
```

### Remove the Image

```bash
sudo docker rmi nautilus-apache:latest
```

## Additional Commands

### Rebuild Image (Force Rebuild)

```bash
sudo docker build --no-cache -t nautilus-apache:latest /opt/docker/
```

### Tag Image for Repository

```bash
sudo docker tag nautilus-apache:latest your-registry/nautilus-apache:latest
```

### Push to Registry

```bash
sudo docker push your-registry/nautilus-apache:latest
```

## Security Notes

- The image runs Apache as root (default Ubuntu Apache behavior)
- For production, consider creating a non-root user
- Keep the base image updated regularly
- Review and apply security patches

## Support

For issues or questions regarding this Docker configuration, please contact the DevOps team or refer to the Nautilus project documentation.

## Version History

- **v1.0** - Initial release with Ubuntu 24.04 and Apache2 on port 8087

---

**Created for**: Nautilus Application Development Team  
**Target Environment**: App Server 1, Stratos DC  
**Last Updated**: October 2025
