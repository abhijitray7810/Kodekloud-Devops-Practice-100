# Docker Image Creation from Running Container

## Overview
This guide provides instructions for creating a Docker image from a running container on Application Server 3. This is useful for backing up changes made to a container before deploying or testing new modifications.

## Task Details

| Parameter | Value |
|-----------|-------|
| **Server** | Application Server 3 |
| **Source Container** | `ubuntu_latest` |
| **Target Image** | `games:nautilus` |
| **Operation** | Create image from running container |

## Prerequisites

- SSH access to Application Server 3
- Docker installed and running
- Container `ubuntu_latest` must be running
- Appropriate permissions to execute Docker commands

## Implementation Steps

### Step 1: Connect to Application Server 3

```bash
ssh username@app-server-3
```

### Step 2: Verify Container Status

Check if the source container is running:

```bash
docker ps | grep ubuntu_latest
```

Expected output should show the container in running state.

### Step 3: Create Image from Container

Execute the docker commit command:

```bash
docker commit ubuntu_latest games:nautilus
```

This command will create a new image named `games:nautilus` with all the changes from the `ubuntu_latest` container.

### Step 4: Verify Image Creation

Confirm the image was created successfully:

```bash
docker images games
```

You should see the `games` image with tag `nautilus` in the output.

## Command Reference

### Basic Commit Command
```bash
docker commit <container-name> <image-name>:<tag>
```

### Commit with Metadata (Optional)
```bash
docker commit -a "Author Name" -m "Commit message" ubuntu_latest games:nautilus
```

**Options:**
- `-a, --author`: Specify author information
- `-m, --message`: Add a commit message describing the changes
- `-p, --pause`: Pause container during commit (default: true)

## Verification

### Check Image Details
```bash
docker inspect games:nautilus
```

### Test the New Image
Run a container from the newly created image to verify changes:

```bash
docker run -it games:nautilus /bin/bash
```

### List All Images
```bash
docker images
```

## Complete Script

```bash
#!/bin/bash

# Verify the container is running
echo "Checking if container 'ubuntu_latest' is running..."
docker ps | grep ubuntu_latest

# Create image from the running container
echo "Creating image 'games:nautilus' from container 'ubuntu_latest'..."
docker commit ubuntu_latest games:nautilus

# Verify the image was created successfully
echo "Verifying the newly created image..."
docker images | grep games

echo "✓ Image 'games:nautilus' has been created successfully!"
```

## Troubleshooting

### Container Not Found
```bash
# List all running containers
docker ps -a
```

### Permission Denied
```bash
# Add user to docker group or use sudo
sudo docker commit ubuntu_latest games:nautilus
```

### Image Already Exists
```bash
# Remove existing image first
docker rmi games:nautilus
# Then create the new image
docker commit ubuntu_latest games:nautilus
```

## Best Practices

1. **Pause Container**: The container is paused by default during commit to ensure consistency
2. **Add Metadata**: Use `-a` and `-m` flags to document changes
3. **Tag Appropriately**: Use meaningful tags to track versions
4. **Verify Changes**: Always test the new image before using it in production
5. **Clean Up**: Remove old unused images to save disk space

## Additional Operations

### Export Image (Optional)
To export the image for transfer to another server:

```bash
docker save games:nautilus > games-nautilus.tar
```

### Tag Image with Additional Tags
```bash
docker tag games:nautilus games:latest
docker tag games:nautilus games:v1.0
```

### Push to Registry (Optional)
If you have a Docker registry:

```bash
docker tag games:nautilus registry.example.com/games:nautilus
docker push registry.example.com/games:nautilus
```

## Notes

- The `docker commit` command preserves the current state of the container's filesystem
- Environment variables, exposed ports, and volumes are inherited from the base image
- Changes to mounted volumes are NOT included in the committed image
- The container can continue running during and after the commit operation

## Support

For issues or questions, contact the DevOps team or refer to the official Docker documentation:
- [Docker Commit Documentation](https://docs.docker.com/engine/reference/commandline/commit/)

---

**Created for**: Nautilus DevOps Team  
**Last Updated**: October 2025
