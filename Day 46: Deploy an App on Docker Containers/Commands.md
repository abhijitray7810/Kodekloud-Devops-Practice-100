# Docker Compose Deployment — Nautilus App (App Server 3)

## Step 1: Create required directory
```bash
sudo mkdir -p /opt/dba
cd /opt/dba
````

## Step 2: Create docker-compose.yml file

```bash
sudo vi /opt/dba/docker-compose.yml
```

### Add the following content inside it:

```yaml
version: '3'

services:
  web:
    container_name: php_blog
    image: php:apache
    ports:
      - "8084:80"
    volumes:
      - /var/www/html:/var/www/html
    depends_on:
      - db

  db:
    container_name: mysql_blog
    image: mariadb:latest
    environment:
      MYSQL_DATABASE: database_blog
      MYSQL_USER: blog_user
      MYSQL_PASSWORD: MyC0mpl3xP@ss
      MYSQL_ROOT_PASSWORD: rootPass123
    ports:
      - "3306:3306"
    volumes:
      - /var/lib/mysql:/var/lib/mysql
```

## Step 3: Bring up the Docker Compose stack

```bash
sudo docker compose -f /opt/dba/docker-compose.yml up -d
```

## Step 4: Verify running containers

```bash
docker ps
```

Expected output should list:

```
php_blog
mysql_blog
```

## Step 5: Test web access

```bash
curl http://localhost:8084/
```

or use:

```bash
curl http://<server-ip>:8084/
```

## Step 6: (Optional) Create a test PHP file to verify web server

```bash
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/index.php
```

Then test again:

```bash
curl http://localhost:8084/
```

---

✅ **Summary**

* Compose file path: `/opt/dba/docker-compose.yml`
* Web container: **php_blog** (ports 8084:80)
* DB container: **mysql_blog** (ports 3306:3306)
* Database: **database_blog**
* User: **blog_user**
* Password: **MyC0mpl3xP@ss**

---

```

Would you like me to generate this as a downloadable `command.md` file (so you can upload it directly to your lab)?
```
