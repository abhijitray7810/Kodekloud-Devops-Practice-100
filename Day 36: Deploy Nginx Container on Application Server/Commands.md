# Nginx Container Deployment on Application Server 1

## Task Description
The Nautilus DevOps team requires deploying an Nginx container using the **nginx:alpine** image on **Application Server 1**.  
The container should be named **nginx_1** and must remain in a running state.

---

## Steps and Commands

### 1. SSH into Application Server 1
```bash
ssh tony@stapp01
````

*(Replace `tony@stapp01` with the appropriate username and hostname for your environment.)*

---

### 2. Verify Docker installation

```bash
docker --version
```

Start Docker service if it’s not running:

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

---

### 3. Pull the nginx image (alpine version)

```bash
sudo docker pull nginx:alpine
```

Verify the image:

```bash
sudo docker images
```

---

### 4. Create and run the container

```bash
sudo docker run -d --name nginx_1 nginx:alpine
```

---

### 5. Verify container status

```bash
sudo docker ps
```

Expected output:

```
CONTAINER ID   IMAGE          COMMAND                  STATUS         PORTS     NAMES
<id>           nginx:alpine   "/docker-entrypoint.…"   Up XX seconds            nginx_1
```

---

### 6. (Optional) Check nginx service inside the container

```bash
sudo docker exec -it nginx_1 sh
curl -I localhost
exit
```

Expected response:

```
HTTP/1.1 200 OK
```

---

## ✅ Verification Checklist

* [x] Container name: `nginx_1`
* [x] Image used: `nginx:alpine`
* [x] Container status: Running

---

```

---

Would you like me to include a short **“Troubleshooting”** section at the end (e.g., how to fix permission or network errors)?
```
