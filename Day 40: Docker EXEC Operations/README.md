# Apache Configuration on kkloud Container

## Project Overview
This document provides instructions for configuring Apache2 web server on the `kkloud` container running on App Server 3 in Stratos Datacenter.

## Prerequisites
- Access to App Server 3 in Stratos Datacenter
- SSH credentials for App Server 3
- Docker installed and running on App Server 3
- `kkloud` container must be running
- Sudo/root privileges on App Server 3

## Task Requirements
1. Install `apache2` package using `apt` in the `kkloud` container
2. Configure Apache to listen on port `8082` instead of default port 80
3. Apache should listen on all interfaces (not bound to specific IP/hostname)
4. Ensure Apache service is running
5. Keep the container in running state

## Installation Steps

### Step 1: Connect to App Server 3
```bash
ssh <username>@<app-server-3-hostname>
```

### Step 2: Verify Container Status
```bash
# Check if kkloud container is running
sudo docker ps | grep kkloud

# If container is not running, start it
sudo docker start kkloud
```

### Step 3: Access the Container
```bash
sudo docker exec -it kkloud /bin/bash
```

### Step 4: Install Apache2
```bash
# Update package repository
apt update

# Install apache2
apt install -y apache2
```

### Step 5: Configure Apache to Listen on Port 8082
```bash
# Modify ports.conf to listen on 8082
sed -i 's/Listen 80/Listen 8082/' /etc/apache2/ports.conf

# Update default virtual host configuration
sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8082>/' /etc/apache2/sites-available/000-default.conf
```

### Step 6: Start Apache Service
```bash
# Start Apache service
service apache2 start

# Check Apache service status
service apache2 status
```

### Step 7: Exit Container
```bash
# Exit the container (keep it running)
exit
```

## One-Line Installation (Alternative Method)

If you prefer to execute all commands at once from App Server 3:

```bash
sudo docker exec -it kkloud /bin/bash -c "
apt update && 
apt install -y apache2 && 
sed -i 's/Listen 80/Listen 8082/' /etc/apache2/ports.conf && 
sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8082>/' /etc/apache2/sites-available/000-default.conf && 
service apache2 start && 
service apache2 status
"
```

## Verification

### Verify Container is Running
```bash
sudo docker ps | grep kkloud
```

### Verify Apache is Installed
```bash
sudo docker exec kkloud which apache2
```

### Verify Apache is Listening on Port 8082
```bash
sudo docker exec kkloud netstat -tlnp | grep 8082
# OR
sudo docker exec kkloud ss -tlnp | grep 8082
```

### Verify Apache is Serving Content
```bash
# Check from inside container
sudo docker exec kkloud curl -I http://localhost:8082

# Check the response (should see HTTP/1.1 200 OK)
sudo docker exec kkloud curl http://localhost:8082
```

### Verify Apache Process is Running
```bash
sudo docker exec kkloud ps aux | grep apache2
```

## Configuration Files Modified

| File | Location | Changes |
|------|----------|---------|
| ports.conf | /etc/apache2/ports.conf | Changed `Listen 80` to `Listen 8082` |
| 000-default.conf | /etc/apache2/sites-available/000-default.conf | Changed `<VirtualHost *:80>` to `<VirtualHost *:8082>` |

## Troubleshooting

### Apache Service Won't Start
```bash
# Check Apache configuration syntax
sudo docker exec kkloud apache2ctl configtest

# Check Apache error logs
sudo docker exec kkloud cat /var/log/apache2/error.log
```

### Port Already in Use
```bash
# Check what's using port 8082
sudo docker exec kkloud netstat -tlnp | grep 8082

# Kill the process if needed (replace PID)
sudo docker exec kkloud kill -9 <PID>
```

### Container Stops After Exiting
```bash
# Restart the container
sudo docker start kkloud

# Check container logs
sudo docker logs kkloud
```

### Apache Service Not Persistent After Container Restart
If Apache doesn't start automatically after container restart, you may need to configure it to start on boot or manually start it after each container restart:

```bash
# Start Apache after container restart
sudo docker exec kkloud service apache2 start
```

## Service Management Commands

```bash
# Start Apache
sudo docker exec kkloud service apache2 start

# Stop Apache
sudo docker exec kkloud service apache2 stop

# Restart Apache
sudo docker exec kkloud service apache2 restart

# Reload Apache configuration
sudo docker exec kkloud service apache2 reload

# Check Apache status
sudo docker exec kkloud service apache2 status
```

## Important Notes

1. **Port Binding**: Apache is configured to listen on `0.0.0.0:8082`, meaning it accepts connections on all network interfaces
2. **Container State**: The container remains running after configuration
3. **Persistence**: If the container is recreated, these configurations will be lost unless the image is committed or volumes are used
4. **Security**: Ensure appropriate firewall rules are in place if exposing port 8082

## Testing Access

### From Inside Container
```bash
sudo docker exec kkloud curl http://localhost:8082
sudo docker exec kkloud curl http://127.0.0.1:8082
```

### From App Server 3 Host
```bash
# Get container IP
CONTAINER_IP=$(sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' kkloud)

# Test connection
curl http://$CONTAINER_IP:8082
```

### From Another Server (if network allows)
```bash
curl http://<app-server-3-ip>:8082
```

## Success Criteria

- ✅ Apache2 is installed in the kkloud container
- ✅ Apache is configured to listen on port 8082
- ✅ Apache listens on all interfaces (0.0.0.0)
- ✅ Apache service is running
- ✅ Container remains in running state
- ✅ Apache responds to HTTP requests on port 8082

## Additional Resources

- [Apache HTTP Server Documentation](https://httpd.apache.org/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [Apache Configuration Files](https://httpd.apache.org/docs/2.4/configuring.html)

## Author Information
- **Datacenter**: Stratos Datacenter
- **Server**: App Server 3
- **Container**: kkloud
- **Date**: 2025-10-19

## Support
For issues or questions, contact the Nautilus DevOps team.
 
