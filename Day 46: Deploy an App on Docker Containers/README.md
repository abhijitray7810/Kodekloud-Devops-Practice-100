# PHP Blog Application - Docker Compose Deployment

## Overview
This project deploys a containerized PHP blog application with MariaDB database using Docker Compose on App Server 3 in the Stratos Datacenter.

## Architecture
The application stack consists of two services:
- **Web Service**: PHP with Apache web server
- **Database Service**: MariaDB database server

## Prerequisites
- Docker installed on App Server 3
- Docker Compose (either standalone or plugin)
- Sudo access to the server
- Ports 8084 and 3306 available on the host

## File Structure
```
/opt/dba/
└── docker-compose.yml
```

## Configuration Details

### Web Service (php_blog)
- **Container Name**: `php_blog`
- **Image**: `php:apache`
- **Port Mapping**: `8084:80` (Host:Container)
- **Volume Mapping**: `/var/www/html:/var/www/html`
- **Dependencies**: Starts after DB service

### Database Service (mysql_blog)
- **Container Name**: `mysql_blog`
- **Image**: `mariadb:latest`
- **Port Mapping**: `3306:3306` (Host:Container)
- **Volume Mapping**: `/var/lib/mysql:/var/lib/mysql`
- **Environment Variables**:
  - `MYSQL_DATABASE`: database_blog
  - `MYSQL_USER`: blog_user
  - `MYSQL_PASSWORD`: Bl0g_P@ssw0rd!2024
  - `MYSQL_ROOT_PASSWORD`: R00t_P@ssw0rd!2024

## Installation Steps

### 1. Create Directory Structure
```bash
sudo mkdir -p /opt/dba
cd /opt/dba
```

### 2. Create docker-compose.yml
Copy the docker-compose.yml content to `/opt/dba/docker-compose.yml`

```bash
sudo vi /opt/dba/docker-compose.yml
# Or
sudo nano /opt/dba/docker-compose.yml
```

### 3. Check Docker Compose Installation
```bash
# Method 1: Docker Compose Plugin (modern)
sudo docker compose version

# Method 2: Standalone docker-compose
docker-compose --version
```

### 4. Install Docker Compose (if needed)

#### Option A: Install Docker Compose Plugin
```bash
sudo yum install docker-compose-plugin -y
# or for newer systems
sudo dnf install docker-compose-plugin -y
```

#### Option B: Install Standalone Docker Compose
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

## Deployment

### Start the Stack
```bash
cd /opt/dba

# Using Docker Compose Plugin (recommended)
sudo docker compose up -d

# OR using standalone docker-compose
sudo docker-compose up -d
```

### Verify Deployment
```bash
# Check running containers
sudo docker ps

# Check compose services status
sudo docker compose ps

# Test the web application
curl localhost:8084/
curl http://<server-ip>:8084/
```

## Management Commands

### View Logs
```bash
# All services
sudo docker compose logs -f

# Specific service
sudo docker compose logs -f web
sudo docker compose logs -f db
```

### Stop the Stack
```bash
sudo docker compose down
```

### Restart Services
```bash
# Restart all services
sudo docker compose restart

# Restart specific service
sudo docker compose restart web
sudo docker compose restart db
```

### Rebuild and Deploy
```bash
sudo docker compose down
sudo docker compose up -d --build
```

### Remove Everything (including volumes)
```bash
sudo docker compose down -v
```

## Troubleshooting

### Issue: docker-compose command not found
**Solution**: Use `docker compose` (with space) instead of `docker-compose` (with hyphen)
```bash
sudo docker compose up -d
```

### Issue: Port already in use
**Solution**: Check and stop conflicting services
```bash
# Check what's using port 8084
sudo netstat -tulpn | grep 8084
sudo lsof -i :8084

# Stop conflicting container
sudo docker stop <container-id>
```

### Issue: Permission denied on volumes
**Solution**: Ensure proper permissions on host directories
```bash
sudo mkdir -p /var/www/html /var/lib/mysql
sudo chown -R 33:33 /var/www/html  # www-data user
sudo chmod -R 755 /var/www/html
```

### Issue: Database connection fails
**Solution**: Check database container logs
```bash
sudo docker compose logs db
# Ensure database is fully initialized before web service connects
```

### Issue: Cannot access application
**Solution**: Verify firewall settings
```bash
# Check if port is open
sudo firewall-cmd --list-ports

# Add port if needed
sudo firewall-cmd --permanent --add-port=8084/tcp
sudo firewall-cmd --reload
```

## Database Access

### Connect to MariaDB Container
```bash
sudo docker exec -it mysql_blog mysql -u blog_user -p
# Password: Bl0g_P@ssw0rd!2024
```

### Connect as Root
```bash
sudo docker exec -it mysql_blog mysql -u root -p
# Password: R00t_P@ssw0rd!2024
```

### Database Operations
```sql
-- Show databases
SHOW DATABASES;

-- Use the blog database
USE database_blog;

-- Show tables
SHOW TABLES;

-- Check user privileges
SHOW GRANTS FOR 'blog_user'@'%';
```

## Network Details
- **Network Name**: blog_network
- **Driver**: bridge
- **Purpose**: Enables container-to-container communication

### Inspect Network
```bash
sudo docker network ls
sudo docker network inspect blog_network
```

## Security Considerations
1. **Passwords**: Change default passwords in production
2. **Firewall**: Ensure only necessary ports are exposed
3. **Updates**: Regularly update container images
4. **Volumes**: Backup database volumes regularly

## Backup and Restore

### Backup Database
```bash
sudo docker exec mysql_blog mysqldump -u blog_user -pBl0g_P@ssw0rd!2024 database_blog > backup.sql
```

### Restore Database
```bash
sudo docker exec -i mysql_blog mysql -u blog_user -pBl0g_P@ssw0rd!2024 database_blog < backup.sql
```

### Backup Volumes
```bash
sudo tar -czf /tmp/www_backup.tar.gz /var/www/html
sudo tar -czf /tmp/mysql_backup.tar.gz /var/lib/mysql
```

## Testing

### Test Web Service
```bash
# Local test
curl -I localhost:8084

# Remote test
curl -I http://<server-ip>:8084

# Full response
curl localhost:8084
```

### Test Database Connectivity
```bash
# From web container
sudo docker exec php_blog ping mysql_blog

# Test MySQL connection
sudo docker exec php_blog nc -zv mysql_blog 3306
```

## Monitoring

### Resource Usage
```bash
# All containers
sudo docker stats

# Specific container
sudo docker stats php_blog mysql_blog
```

### Container Health
```bash
sudo docker inspect php_blog | grep -A 10 State
sudo docker inspect mysql_blog | grep -A 10 State
```

## Cleanup

### Remove All Containers and Networks
```bash
sudo docker compose down

# Include volumes
sudo docker compose down -v

# Remove images as well
sudo docker compose down --rmi all -v
```

## Support and Documentation
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PHP Docker Image](https://hub.docker.com/_/php)
- [MariaDB Docker Image](https://hub.docker.com/_/mariadb)

## Notes
- Once you click FINISH button in the deployment system, all running/stopped containers will be destroyed and the stack will be redeployed using this compose file
- Ensure the compose file is named exactly `docker-compose.yml` in `/opt/dba/`
- The web service depends on the database service, ensuring proper startup order

## Version History
- **v1.0**: Initial deployment with PHP Apache and MariaDB services
