# 🐳 Docker Network Configuration — Nautilus DevOps Project

## Task Description
As per the recent requirements from the Nautilus DevOps team, we need to set up several Docker environments for different applications.  
This specific task involves creating a custom Docker network on **App Server 2**.

---

## 🎯 Objectives
- Create a Docker network named **`news`**
- Use **bridge** as the network driver
- Configure with:
  - **Subnet:** `192.168.0.0/24`
  - **IP Range:** `192.168.0.0/24`

---

## 🧠 Steps to Complete

### 1️⃣ Connect to App Server 2
```bash
ssh tony@stapp02
````

*(Replace `tony` and hostname with actual credentials if required.)*

---

### 2️⃣ Verify Docker Service

Check if Docker is active:

```bash
sudo systemctl status docker
```

If not running, start it:

```bash
sudo systemctl start docker
```

---

### 3️⃣ Create Docker Network

Run the following command to create the network:

```bash
sudo docker network create \
  --driver bridge \
  --subnet 192.168.0.0/24 \
  --ip-range 192.168.0.0/24 \
  news
```

---

### 4️⃣ Verify Network Creation

List all Docker networks:

```bash
sudo docker network ls
```

Expected output:

```
NETWORK ID     NAME      DRIVER    SCOPE
abc12345ef67   news      bridge    local
```

---

### 5️⃣ Inspect Network Configuration

Check detailed configuration:

```bash
sudo docker network inspect news
```

Expected configuration snippet:

```json
"IPAM": {
    "Driver": "default",
    "Config": [
        {
            "Subnet": "192.168.0.0/24",
            "IPRange": "192.168.0.0/24"
        }
    ]
}
```

---

## ✅ Final Verification

Run this command to quickly confirm:

```bash
sudo docker network inspect news | grep -E "Subnet|IPRange|Driver"
```

Expected output:

```
"Driver": "bridge",
"Subnet": "192.168.0.0/24",
"IPRange": "192.168.0.0/24"
```

---

## 🏁 Task Completed

The Docker network **`news`** has been successfully created and configured using the bridge driver with the specified subnet and IP range on **App Server 2**.

---

```

---

Would you like me to include a **short “Project Description + GitHub section”** at the top (like your other Nautilus posts) so it looks portfolio-ready for LinkedIn or GitHub?
```
