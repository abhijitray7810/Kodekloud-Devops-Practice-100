# Task: Copy Encrypted File into Container

## Objective
Copy the encrypted file `/tmp/nautilus.txt.gpg` from the Docker host to the `ubuntu_latest` container without modifying its content.  
The file should be placed inside the container at `/usr/src/`.

---

## Steps Performed

### 1. SSH into App Server 1
```bash
ssh tony@stapp01
````

---

### 2. Verify Running Container

```bash
sudo docker ps | grep ubuntu_latest
```

**Output:**

```
21833b53f89e   ubuntu    "/bin/bash"   Up 5 minutes   ubuntu_latest
```

---

### 3. Copy the Encrypted File to the Container

```bash
sudo docker cp /tmp/nautilus.txt.gpg ubuntu_latest:/usr/src/
```

**Output:**

```
Successfully copied 2.05kB to ubuntu_latest:/usr/src/
```

---

### 4. Verify File Inside the Container

```bash
sudo docker exec -it ubuntu_latest ls -l /usr/src/
```

**Output:**

```
-rw-r--r-- 1 root root 105 Oct 16 05:05 nautilus.txt.gpg
```

---

### 5. Verify File Integrity (Checksum Comparison)

#### On Host:

```bash
sha256sum /tmp/nautilus.txt.gpg
```

#### Inside Container:

```bash
sudo docker exec ubuntu_latest sha256sum /usr/src/nautilus.txt.gpg
```

**Both Outputs:**

```
4c7125852a1326a76df49a5510097299ac73b2b7d97a2ef84bf205ef99f105f7
```

✅ Checksums match — file copied without modification.

---

## ✅ Final Result

Encrypted file successfully copied to the container:

```
/usr/src/nautilus.txt.gpg
```

File integrity verified.

```

