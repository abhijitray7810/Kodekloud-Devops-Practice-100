# Dockerfile Troubleshooting Guide - App Server 3

## Overview
This guide provides instructions for fixing and building a Docker image on App Server 3 in Stratos DC as per the Nautilus DevOps team requirements.

## Environment Details
- **Server**: App Server 3 (stapp03)
- **User**: banner
- **Dockerfile Location**: `/opt/docker/`
- **Requirements**: Fix build errors without changing base image or valid configurations

## Prerequisites
- SSH access to App Server 3
- Sudo privileges for Docker commands
- Basic understanding of Dockerfile syntax

## Step-by-Step Instructions

### 1. Connect to App Server 3
```bash
ssh banner@stapp03
```

### 2. Navigate to Docker Directory
```bash
cd /opt/docker
```

### 3. Examine the Current Dockerfile
```bash
cat Dockerfile
ls -la
```

### 4. Common Dockerfile Issues to Check

#### Issue 1: Missing Line Continuation Characters
**Problem:**
```dockerfile
RUN apt-get update
    apt-get install -y nginx
```

**Solution:**
```dockerfile
RUN apt-get update && \
    apt-get install -y nginx
```

#### Issue 2: Incorrect Command Chaining
**Problem:**
```dockerfile
RUN yum install httpd
RUN yum install wget
```

**Solution:**
```dockerfile
RUN yum install -y httpd && \
    yum install -y wget
```

#### Issue 3: Missing Arguments or Flags
**Problem:**
```dockerfile
RUN yum install httpd
```

**Solution:**
```dockerfile
RUN yum install -y httpd
```

#### Issue 4: Typos in Commands or Package Names
- Check spelling of package names
- Verify command syntax
- Ensure proper spacing

#### Issue 5: File Path Issues
**Problem:**
```dockerfile
COPY index.html /invalid/path/
```

**Solution:**
```dockerfile
COPY index.html /usr/share/nginx/html/
```

### 5. Edit the Dockerfile
```bash
sudo vi Dockerfile
# or
sudo nano Dockerfile
```

### 6. Build the Docker Image
```bash
sudo docker build -t fixed-image .
```

### 7. Verify Successful Build
```bash
sudo docker images
sudo docker images | grep fixed-image
```

### 8. Test the Container (Optional)
```bash
sudo docker run -d -p 8080:80 fixed-image
sudo docker ps
```

## Common Dockerfile Syntax Reference

### Valid RUN Command Formats
```dockerfile
# Single command
RUN apt-get update

# Multiple commands (same line)
RUN apt-get update && apt-get install -y nginx

# Multiple commands (multi-line)
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean
```

### COPY/ADD Commands
```dockerfile
COPY source destination
COPY index.html /var/www/html/
ADD archive.tar.gz /app/
```

### WORKDIR Command
```dockerfile
WORKDIR /app
```

### EXPOSE Command
```dockerfile
EXPOSE 80
EXPOSE 443
```

### CMD/ENTRYPOINT
```dockerfile
CMD ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["docker-entrypoint.sh"]
```

## Troubleshooting Tips

### If Build Fails
1. **Read error messages carefully** - They usually indicate the line number
2. **Check for typos** - Commands, package names, file paths
3. **Verify file existence** - Ensure files being COPYed exist
4. **Check syntax** - Missing `\`, `&&`, or quotes
5. **Review base image compatibility** - Commands must work with the base OS

### Common Error Messages

| Error Message | Likely Cause | Solution |
|--------------|--------------|----------|
| `unknown instruction` | Typo in Dockerfile instruction | Check spelling of RUN, COPY, FROM, etc. |
| `returned a non-zero code` | Command execution failed | Check command syntax and package availability |
| `no such file or directory` | COPY/ADD source doesn't exist | Verify file paths |
| `failed to solve with frontend dockerfile.v0` | Syntax error in Dockerfile | Check for missing `\` or `&&` |

## Important Constraints

⚠️ **DO NOT CHANGE:**
- Base image (FROM instruction)
- Any valid configuration settings
- Content of index.html or other data files
- Working directory structure

✅ **ALLOWED TO FIX:**
- Line continuation characters (`\`)
- Command chaining operators (`&&`)
- Missing flags (like `-y` for package managers)
- Typos in commands or package names
- Syntax errors

## Verification Checklist

- [ ] Dockerfile syntax is correct
- [ ] All multi-line commands have proper `\` continuation
- [ ] Commands are chained with `&&` where appropriate
- [ ] Package manager flags (like `-y`) are present
- [ ] File paths in COPY/ADD are correct
- [ ] Base image remains unchanged
- [ ] Docker build completes without errors
- [ ] Image is created successfully

## Example Dockerfile Structure

```dockerfile
# Base image (DO NOT CHANGE)
FROM centos:7

# Maintainer
LABEL maintainer="devops@example.com"

# Install packages
RUN yum install -y httpd && \
    yum install -y wget && \
    yum clean all

# Copy files
COPY index.html /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Expose port
EXPOSE 80

# Start service
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
```

## Additional Resources

- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Docker Build Documentation](https://docs.docker.com/engine/reference/commandline/build/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/dev-best-practices/)

## Notes

- Once you click **FINISH**, all existing containers will be destroyed
- A new image will be built from your corrected Dockerfile
- Ensure thorough testing before finalizing
- Keep backup of original Dockerfile if needed: `cp Dockerfile Dockerfile.backup`

## Support

For additional help or issues:
- Review Docker build logs: `sudo docker build -t test-image . 2>&1 | tee build.log`
- Check Docker daemon status: `sudo systemctl status docker`
- Verify Docker installation: `docker --version`
