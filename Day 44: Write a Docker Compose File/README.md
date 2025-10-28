# Apache HTTPD Container Setup Guide

## Overview

This repository contains the Docker Compose configuration for deploying the Apache HTTP Server (httpd) container on App Server 2 in Stratos DC. The setup hosts static website content provided by the Nautilus application development team.

## Prerequisites

- Docker installed and running on App Server 2
- Docker Compose installed (version 3.8 or higher)
- Access to App Server 2 in Stratos DC
- `/opt/sysops` directory exists on the host system

## Architecture

**Server**: App Server 2 (Stratos DC)  
**Container Name**: httpd  
**Image**: httpd:latest  
**Host Port**: 8086  
**Container Port**: 80  
**Volume Mount**: `/opt/sysops` (host) → `/usr/local/apache2/htdocs` (container)

## Project Structure

```
/opt/docker/
└── docker-compose.yml
/opt/sysops/
└── [static website content]
```

## Installation

### Step 1: Connect to App Server 2

```bash
ssh user@app-server-2
```

### Step 2: Create Docker Directory

```bash
sudo mkdir -p /opt/docker
cd /opt/docker
```

### Step 3: Create docker-compose.yml

Create the file at `/opt/docker/docker-compose.yml` with the following content:

```yaml
version: '3.8'

services:
  httpd-service:
    image: httpd:latest
    container_name: httpd
    ports:
      - "8086:80"
    volumes:
      - /opt/sysops:/usr/local/apache2/htdocs
    restart: unless-stopped
```

### Step 4: Deploy the Container

```bash
sudo docker-compose up -d
```

## Usage

### Starting the Container

```bash
cd /opt/docker
sudo docker-compose up -d
```

### Stopping the Container

```bash
cd /opt/docker
sudo docker-compose down
```

### Restarting the Container

```bash
cd /opt/docker
sudo docker-compose restart
```

### Viewing Logs

```bash
cd /opt/docker
sudo docker-compose logs -f httpd-service
```

## Verification

### Check Container Status

```bash
sudo docker ps | grep httpd
```

Expected output should show a running container named `httpd`.

### Check Docker Compose Status

```bash
cd /opt/docker
sudo docker-compose ps
```

### Test Web Server

Test locally on App Server 2:

```bash
curl http://localhost:8086
```

Test from another machine (if accessible):

```bash
curl http://app-server-2:8086
```

## Configuration Details

| Parameter | Value | Description |
|-----------|-------|-------------|
| Container Name | `httpd` | Name of the Docker container |
| Image | `httpd:latest` | Apache HTTP Server official image |
| Service Name | `httpd-service` | Docker Compose service identifier |
| Host Port | `8086` | Port exposed on the Docker host |
| Container Port | `80` | Apache default HTTP port |
| Volume (Host) | `/opt/sysops` | Directory containing static content |
| Volume (Container) | `/usr/local/apache2/htdocs` | Apache document root |
| Restart Policy | `unless-stopped` | Container auto-restart behavior |

## Managing Static Content

All static website content should be placed in `/opt/sysops/` on the host system. Any files placed in this directory will be automatically served by the Apache httpd container.

**Important**: Do not modify or delete existing data in `/opt/sysops/`.

### Adding Content

```bash
# Copy files to the web root
sudo cp -r /path/to/your/website/* /opt/sysops/

# Set appropriate permissions if needed
sudo chown -R www-data:www-data /opt/sysops/
```

## Troubleshooting

### Container Not Starting

Check logs for errors:

```bash
sudo docker-compose logs httpd-service
```

### Port Already in Use

If port 8086 is already in use, check what's using it:

```bash
sudo netstat -tulpn | grep 8086
```

### Permission Issues

Ensure the `/opt/sysops` directory has proper permissions:

```bash
sudo ls -la /opt/sysops
```

### Container Crashes

View detailed logs:

```bash
sudo docker logs httpd
```

Inspect container:

```bash
sudo docker inspect httpd
```

## Maintenance

### Updating the Image

```bash
cd /opt/docker
sudo docker-compose pull
sudo docker-compose up -d
```

### Cleaning Up

Remove the container:

```bash
cd /opt/docker
sudo docker-compose down
```

Remove the container and volumes (WARNING: This will delete data):

```bash
cd /opt/docker
sudo docker-compose down -v
```

## Security Considerations

- The container runs with default httpd security settings
- Only port 8086 is exposed on the host
- The container uses the `unless-stopped` restart policy for availability
- Ensure firewall rules are configured appropriately for port 8086

## Support

For issues or questions, contact the DevOps team or refer to:

- [Apache HTTP Server Documentation](https://httpd.apache.org/docs/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Hub - httpd Image](https://hub.docker.com/_/httpd)

## Version History

- **v1.0** - Initial setup with httpd:latest container configuration

## Notes

- The `/opt/sysops` directory must exist before starting the container
- Do not modify the docker-compose.yml file name or location (`/opt/docker/docker-compose.yml`)
- The container will automatically restart unless explicitly stopped
- Static content changes in `/opt/sysops` are reflected immediately (no container restart needed)
