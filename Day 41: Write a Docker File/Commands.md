## 🐳 **command.md**

# Nautilus DevOps Project – Dockerfile Setup for Apache on Ubuntu

## 🧾 Task Description
Create a Dockerfile on **App Server 1** in Stratos DC to build a custom image with:
- Base image: `ubuntu:24.04`
- Install `apache2`
- Configure Apache to run on port `8087`

---

## ⚙️ Step-by-Step Commands

### 1️⃣ Connect to App Server 1
```bash
ssh banner@stapp01
# Password: Ir0nM@n
````

---

### 2️⃣ Create the /opt/docker directory

```bash
sudo mkdir -p /opt/docker
cd /opt/docker
```

---

### 3️⃣ Create the Dockerfile

```bash
sudo vi Dockerfile
```

Paste the following Dockerfile content:

```Dockerfile
FROM ubuntu:24.04

LABEL maintainer="DevOps Team <devops@nautilus.com>"

RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean

# Configure Apache to listen on port 8087
RUN sed -i 's/80/8087/g' /etc/apache2/ports.conf && \
    sed -i 's/:80/:8087/g' /etc/apache2/sites-available/000-default.conf

# Expose port 8087
EXPOSE 8087

# Start Apache in the foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```

Save and exit:

* In `vi`: press `ESC`, then type `:wq` and hit `Enter`

---

### 4️⃣ Build the Docker image

```bash
sudo docker build -t custom-apache:latest .
```

---

### 5️⃣ Run the container

```bash
sudo docker run -d -p 8087:8087 --name apache-server custom-apache:latest
```

---

### 6️⃣ Verify running container

```bash
sudo docker ps
```

Expected output should show:

```
CONTAINER ID   IMAGE                COMMAND                  PORTS                    NAMES
abc12345def6   custom-apache:latest "/usr/sbin/apache2ct…"   0.0.0.0:8087->8087/tcp   apache-server
```

---

### 7️⃣ Test Apache service

```bash
curl http://localhost:8087
```

You should see the Apache default HTML page output.

---

✅ **Result:**
A working Apache web server running on port `8087` inside a Docker container built from `ubuntu:24.04`.

```
✔ Dockerfile location: /opt/docker/Dockerfile
✔ Apache running on: 8087
✔ Image name: custom-apache:latest
```

---

### 🧑‍💻 Author

**DevOps Engineer:** Abhijit Ray
**Project:** Nautilus DC – Docker Custom Image for Apache

```

---

Would you like me to generate this as a **downloadable `command.md` file** (so you can upload it to your task system or GitHub)?
```
