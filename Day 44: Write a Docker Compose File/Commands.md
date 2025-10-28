# Commands for Deploying httpd Container with Docker Compose

Below are the commands to create and deploy the httpd container on App Server 2 in Stratos DC.

---

## 1. Create the Docker Compose file directory
```bash
sudo mkdir -p /opt/docker
```

---

## 2. Create the Docker Compose file
```bash
sudo tee /opt/docker/docker-compose.yml > /dev/null <<EOF
version: '3.8'

services:
  httpd:
    image: httpd:latest
    container_name: httpd
    ports:
      - "8086:80"
    volumes:
      - /opt/sysops:/usr/local/apache2/htdocs
EOF
```

---

## 3. Deploy the container
```bash
cd /opt/docker
sudo docker compose up -d
```

---

## 4. Verify the container is running
```bash
sudo docker ps --filter name=httpd
```

---

## 5. Check container logs (optional)
```bash
sudo docker logs httpd
```

---

## 6. Test access to the static content (from host)
```bash
curl http://localhost:8086
```

---

## 7. Stop and remove the container (if needed)
```bash
cd /opt/docker
sudo docker compose down
```

---

> **Note:** Ensure `/opt/sysops` directory exists and contains the static website content before deploying the container.
```
