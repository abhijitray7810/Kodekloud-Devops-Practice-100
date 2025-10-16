# Docker File Copy Operation - Nautilus DevOps

## Overview

This document provides instructions for copying an encrypted file from the Docker host to a running container in the Stratos Datacenter environment.

## Objective

Copy an encrypted file `/tmp/nautilus.txt.gpg` from **App Server 1** (Docker host) to the `ubuntu_latest` container at the location `/usr/src/` without modifying the file during the operation.

## Prerequisites

- Access to App Server 1 in the Stratos Datacenter
- Docker installed and running on the host
- Container `ubuntu_latest` must be running
- Source file `/tmp/nautilus.txt.gpg` must exist on the host
- Appropriate permissions to execute Docker commands

## Quick Start

### Basic Copy Command

```bash
docker cp /tmp/nautilus.txt.gpg ubuntu_latest:/usr/src/
```

## Detailed Instructions

### Step 1: Verify Source File

Confirm the encrypted file exists on the Docker host:

```bash
ls -lh /tmp/nautilus.txt.gpg
```

**Expected Output:**
```
-rw-r--r-- 1 user user 1.2K Oct 16 10:30 /tmp/nautilus.txt.gpg
```

### Step 2: Check Container Status

Verify that the `ubuntu_latest` container is running:

```bash
docker ps | grep ubuntu_latest
```

**Expected Output:**
```
CONTAINER ID   IMAGE     COMMAND       CREATED        STATUS        NAMES
abc123def456   ubuntu    "/bin/bash"   2 hours ago    Up 2 hours    ubuntu_latest
```

If the container is not running, start it:

```bash
docker start ubuntu_latest
```

### Step 3: Copy the File

Execute the copy command:

```bash
docker cp /tmp/nautilus.txt.gpg ubuntu_latest:/usr/src/
```

**Success Indicator:** No error message means successful copy.

### Step 4: Verify the Copy

Confirm the file exists in the container:

```bash
docker exec ubuntu_latest ls -lh /usr/src/nautilus.txt.gpg
```

**Expected Output:**
```
-rw-r--r-- 1 root root 1.2K Oct 16 10:30 /usr/src/nautilus.txt.gpg
```

### Step 5: Verify File Integrity (Optional)

Compare checksums to ensure the file was not modified:

**Host checksum:**
```bash
md5sum /tmp/nautilus.txt.gpg
```

**Container checksum:**
```bash
docker exec ubuntu_latest md5sum /usr/src/nautilus.txt.gpg
```

Both checksums should match exactly.

## Complete Verification Script

Run the provided bash script for automated verification:

```bash
chmod +x docker_copy_verification.sh
./docker_copy_verification.sh
```

## Technical Details

### Docker CP Command Behavior

- **Preserves file integrity:** Binary copy without modification
- **Maintains permissions:** Original file permissions are preserved
- **No decryption:** GPG-encrypted files remain encrypted
- **Atomic operation:** Copy completes fully or fails (no partial copies)

### File Path Notes

- **Source path:** Absolute path on the Docker host filesystem
- **Destination path:** Uses format `container_name:absolute_path`
- **Trailing slash:** `/usr/src/` ensures copy into directory (not rename)

## Troubleshooting

### Container Not Found

**Error:** `Error: No such container: ubuntu_latest`

**Solution:**
```bash
docker ps -a | grep ubuntu
docker start ubuntu_latest
```

### File Not Found

**Error:** `no such file or directory`

**Solution:** Verify source file path
```bash
find /tmp -name "nautilus.txt.gpg"
```

### Permission Denied

**Error:** `permission denied`

**Solution:** Run with appropriate privileges
```bash
sudo docker cp /tmp/nautilus.txt.gpg ubuntu_latest:/usr/src/
```

### Destination Directory Doesn't Exist

**Solution:** Create the directory first
```bash
docker exec ubuntu_latest mkdir -p /usr/src
docker cp /tmp/nautilus.txt.gpg ubuntu_latest:/usr/src/
```

## Security Considerations

- The file remains encrypted during transfer (GPG encryption intact)
- No decryption keys are exposed during the copy operation
- File permissions should be reviewed after copy for security compliance
- Ensure only authorized personnel have access to both host and container

## Alternative Methods

### Using Docker Exec with Cat (Not Recommended)

```bash
cat /tmp/nautilus.txt.gpg | docker exec -i ubuntu_latest sh -c 'cat > /usr/src/nautilus.txt.gpg'
```

**Note:** `docker cp` is preferred as it's more reliable and preserves metadata.

### Using Volumes (For Persistent Access)

If continuous access is needed, consider mounting a volume:

```bash
docker run -v /tmp:/host_tmp ubuntu_latest
```

## Verification Checklist

- [ ] Source file exists on host
- [ ] Container is running
- [ ] File copied successfully
- [ ] File exists in container at correct path
- [ ] File size matches original
- [ ] Checksums match (if verified)
- [ ] File remains encrypted (GPG format intact)

## Support

For issues or questions regarding this operation:

- Contact: Nautilus DevOps Team
- Location: Stratos Datacenter
- Server: App Server 1

## References

- [Docker CP Documentation](https://docs.docker.com/engine/reference/commandline/cp/)
- [Docker Exec Documentation](https://docs.docker.com/engine/reference/commandline/exec/)
- GPG File Format: Ensures encryption during transfer

---

**Last Updated:** October 16, 2025  
**Environment:** Stratos Datacenter - App Server 1  
**Container:** ubuntu_latest
