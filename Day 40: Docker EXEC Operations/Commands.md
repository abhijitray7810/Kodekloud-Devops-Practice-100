# Apache2 Configuration on kkloud Container - Commands Guide

## Quick Reference Commands

### 1. Access App Server 3
```bash
ssh [username]@stapp03
```

### 2. Access kkloud Container
```bash
docker exec -it kkloud /bin/bash
```

### 3. Install Apache2
```bash
apt update
apt install apache2 -y
```

### 4. Install Text Editor
```bash
apt install vim -y
```

### 5. Configure Apache to Listen on Port 8082

#### Edit ports.conf
```bash
vim /etc/apache2/ports.conf
```
**Change:** `Listen 80` → `Listen 8082`

#### Edit VirtualHost configuration
```bash
vim /etc/apache2/sites-available/000-default.conf
```
**Change:** `<VirtualHost *:80>` → `<VirtualHost *:8082>`

### 6. Start Apache Service
```bash
service apache2 start
```

### 7. Enable Apache to Start on Boot
```bash
systemctl enable apache2
```

### 8. Verify Apache Status
```bash
service apache2 status
```

### 9. Test Apache Configuration
```bash
curl -Ik localhost:8082
```

### 10. Exit Container (Keep Running)
```bash
exit
```

## Verification Commands

### Check Container Status
```bash
docker ps | grep kkloud
```

### Verify Port 8082 is Listening
```bash
docker exec kkloud netstat -tlnp | grep 8082
```

### Test HTTP Response
```bash
docker exec kkloud curl -I localhost:8082
```

### Check Apache Error Logs (if needed)
```bash
docker exec kkloud tail -f /var/log/apache2/error.log
```

## Troubleshooting Commands

### Restart Apache Service
```bash
docker exec kkloud service apache2 restart
```

### Check Apache Configuration Syntax
```bash
docker exec kkloud apache2ctl configtest
```

### View Apache Processes
```bash
docker exec kkloud ps aux | grep apache
```

### Check Port Binding
```bash
docker exec kkloud ss -tlnp | grep 8082
```

## One-Liner Installation Script
```bash
docker exec -it kkloud /bin/bash -c "apt update && apt install apache2 vim -y && sed -i 's/Listen 80/Listen 8082/' /etc/apache2/ports.conf && sed -i 's/*:80/*:8082/' /etc/apache2/sites-available/000-default.conf && service apache2 start && service apache2 status"
```

## Expected Output
- Apache2 installed successfully
- Service listening on port 8082
- HTTP/1.1 200 OK response from curl test
- Container remains in running state
```

This command.md file provides a comprehensive guide with all the commands needed to complete the Apache2 configuration task. You can copy and paste the commands directly or use the one-liner script for a quick setup.
