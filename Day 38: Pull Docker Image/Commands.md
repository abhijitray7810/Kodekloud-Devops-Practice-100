## Task: Pull busybox:musl and re-tag as busybox:media on App Server 2

1. SSH into App Server 2  
   ```bash
   ssh steve@stapp02
   ```

2. Switch to root (if required)  
   ```bash
   sudo su -
   ```

3. Pull the official busybox:musl image  
   ```bash
   docker pull busybox:musl
   ```

4. Re-tag (create new tag)  
   ```bash
   docker tag busybox:musl busybox:media
   ```

5. Verify both tags exist  
   ```bash
   docker images | grep busybox
   ```

Expected output snippet:  
```
busybox   musl   <same-image-id>   <date>   1.43MB  
busybox   media  <same-image-id>   <date>   1.43MB
```
