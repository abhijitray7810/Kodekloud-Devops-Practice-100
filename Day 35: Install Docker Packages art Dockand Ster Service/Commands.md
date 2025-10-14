# commands.md

## CentOS - Install Docker CE and Docker Compose on App Server 1

```bash
# 1. Update system packages
sudo yum update -y

# 2. Install required dependencies
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# 3. Add Docker's official repository
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 4. Install Docker CE, CLI, containerd, buildx and compose plugin
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 5. Start Docker service
sudo systemctl start docker

# 6. Enable Docker to start on boot
sudo systemctl enable docker

# 7. Verify Docker service status
sudo systemctl status docker

# 8. Verify installations
docker version
docker compose version

# 9. Test Docker with hello-world
sudo docker run hello-world
