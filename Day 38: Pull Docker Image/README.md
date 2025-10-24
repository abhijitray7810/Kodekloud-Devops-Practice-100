# Nautilus Project - Docker Image Re-tagging

## Project Overview 
This documentation covers the setup process for the Nautilus project's containerized environment testing. The DevOps team needs to prepare App Server 2 in Stratos DC with a specific busybox image configuration.

## Objective
Pull the `busybox:musl` image and create a new tag `busybox:media` for containerized application feature testing.

## Prerequisites
- Access to App Server 2 in Stratos DC
- Docker installed and running on App Server 2
- Appropriate user permissions to execute Docker commands
- Internet connectivity to pull images from Docker Hub

## Implementation Steps

### Step 1: Connect to App Server 2
```bash
ssh user@app-server-2
```

### Step 2: Pull the busybox:musl Image
```bash
docker pull busybox:musl
```

This command downloads the busybox image with the musl tag from Docker Hub.

### Step 3: Create New Tag (busybox:media)
```bash
docker tag busybox:musl busybox:media
```

This creates a new tag reference pointing to the same image.

### Step 4: Verify the Configuration
```bash
docker images busybox
```

Expected output:
```
REPOSITORY   TAG     IMAGE ID       CREATED       SIZE
busybox      media   <image_id>     X days ago    X MB
busybox      musl    <image_id>     X days ago    X MB
```

## Verification Commands

### List all busybox images
```bash
docker images busybox
```

### Inspect image details
```bash
docker inspect busybox:musl
docker inspect busybox:media
```

### Verify image IDs match
```bash
docker images --format "{{.Repository}}:{{.Tag}} - {{.ID}}" | grep busybox
```

## Important Notes

- **Image ID Identity**: Both `busybox:musl` and `busybox:media` tags point to the same image ID
- **Storage Efficiency**: Creating a new tag does not duplicate the image; no additional disk space is consumed
- **Tag Management**: Tags are simply references/pointers to the same underlying image layers
- **Immutability**: The original `busybox:musl` tag remains intact and unchanged

## Troubleshooting

### Issue: Pull command fails
**Solution**: 
- Check internet connectivity
- Verify Docker daemon is running: `sudo systemctl status docker`
- Check Docker Hub status

### Issue: Permission denied
**Solution**: 
- Add user to docker group: `sudo usermod -aG docker $USER`
- Or use sudo: `sudo docker pull busybox:musl`

### Issue: Image not found after tagging
**Solution**: 
- Ensure the source image exists: `docker images busybox:musl`
- Re-run the tag command with correct syntax

## Cleanup (Optional)

If you need to remove the tags later:
```bash
# Remove only the media tag
docker rmi busybox:media

# Remove both tags
docker rmi busybox:media busybox:musl
```

## Project Information

- **Project**: Nautilus Project
- **Team**: DevOps Team
- **Server**: App Server 2, Stratos DC
- **Task Type**: Containerized Environment Testing Setup
- **Status**: Ready for Testing

## Next Steps

After completing this setup, the development team can proceed with:
1. Testing containerized application features
2. Building custom containers based on busybox:media
3. Implementing application-specific configurations

## Support

For issues or questions, contact the DevOps team or refer to:
- Docker Documentation: https://docs.docker.com
- Project Repository: [Add your repo link]

---

**Document Version**: 1.0  
**Last Updated**: October 17, 2025  
**Maintained By**: DevOps Team
