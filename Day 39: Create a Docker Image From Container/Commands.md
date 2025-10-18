# Docker Image Creation Commands - Application Server 3

## Overview
This document contains the commands to create a new Docker image `games:nautilus` from the running container `ubuntu_latest` on Application Server 3.

## Prerequisites
- SSH access to Application Server 3
- Docker installed and running on Application Server 3
- Container `ubuntu_latest` must be present on the server

## Commands

### 1. Connect to Application Server 3
```bash
ssh user@application-server-3
```

### 2. Verify Container Status
Check if the ubuntu_latest container is running:
```bash
docker ps | grep ubuntu_latest
```

If not running, check all containers:
```bash
docker ps -a | grep ubuntu_latest
```

### 3. Create Image from Container
Basic command to create the image:
```bash
docker commit ubuntu_latest games:nautilus
```

### 4. Create Image with Metadata (Optional)
Add author and description information:
```bash
docker commit -a "Nautilus Developer" -m "Backup of ubuntu_latest container changes" ubuntu_latest games:nautilus
```

### 5. Verify Image Creation
Confirm the image was created successfully:
```bash
docker images | grep games
```

Expected output format:
```
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
games        nautilus  abc123def456   30 seconds ago   XXXMB
```

### 6. Test the New Image (Optional)
Run a test container from the new image:
```bash
docker run -it --rm games:nautilus /bin/bash
```

## Additional Commands

### Save Image as Tar Archive (Optional Backup)
Save the image to a tar file for additional backup:
```bash
docker save -o games_nautilus_backup.tar games:nautilus
```

### Load Image from Tar Archive
If you need to restore from the tar backup:
```bash
docker load -i games_nautilus_backup.tar
```

### Tag the Image with Additional Tags
Add extra tags to the image:
```bash
docker tag games:nautilus games:nautilus-backup
docker tag games:nautilus games:latest-backup
```

## Important Notes

1. **Container State**: The commit operation captures the current filesystem state of the container
2. **Running Containers**: The container can be running or stopped during commit
3. **Pause Option**: By default, the container is paused during commit for consistency
4. **Image Layers**: The new image includes all original layers plus a new layer with changes
5. **Size Consideration**: The image size will reflect the cumulative changes made to the container

## Troubleshooting

### Container Not Found
If you get "No such container" error:
```bash
# List all containers
docker ps -a

# Check container names
docker container ls --format "table {{.Names}}\t{{.Status}}"
```

### Permission Issues
If you get permission denied errors:
```bash
# Check if user is in docker group
groups

# Run with sudo if necessary
sudo docker commit ubuntu_latest games:nautilus
```

### Insufficient Disk Space
Check available disk space before creating image:
```bash
df -h
docker system df
```

## Verification Checklist
- [ ] Connected to Application Server 3
- [ ] Container `ubuntu_latest` is found
- [ ] Image `games:nautilus` created successfully
- [ ] Image appears in `docker images` output
- [ ] Image can be used to create new containers

## Support
For issues or questions regarding these commands, contact the DevOps team.
```

This command.md file provides a comprehensive guide with all the necessary commands, options, and troubleshooting steps for creating the Docker image from the container on Application Server 3.
