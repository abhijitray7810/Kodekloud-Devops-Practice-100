# Dockerfile Fix and Image Build Instructions

## Step 1: Connect to App Server 3
```bash
ssh banner@stapp03
````

## Step 2: Navigate to Docker Directory

```bash
cd /opt/docker
```

## Step 3: Edit and Fix the Dockerfile

Open the Dockerfile and replace its content with the following:

```dockerfile
FROM httpd:2.4.43
MAINTAINER Nautilus DevOps Team

# Change port to 8080
RUN sed -i "s/Listen 80/Listen 8080/g" /usr/local/apache2/conf/httpd.conf

# Enable SSL modules
RUN sed -i '/LoadModule ssl_module modules\/mod_ssl.so/s/^#//g' /usr/local/apache2/conf/httpd.conf
RUN sed -i '/LoadModule socache_shmcb_module modules\/mod_socache_shmcb.so/s/^#//g' /usr/local/apache2/conf/httpd.conf
RUN sed -i '/Include conf\/extra\/httpd-ssl.conf/s/^#//g' /usr/local/apache2/conf/httpd.conf

# Copy SSL certs and HTML content
COPY certs/server.crt /usr/local/apache2/conf/server.crt
COPY certs/server.key /usr/local/apache2/conf/server.key
COPY html/index.html /usr/local/apache2/htdocs/

EXPOSE 8080 443

CMD ["httpd-foreground"]
```

Save and exit.

## Step 4: Build the Docker Image

```bash
docker build -t secure-httpd:latest .
```

## Step 5: Verify Image Creation

```bash
docker images
```

Expected output:

```
REPOSITORY       TAG       IMAGE ID       CREATED          SIZE
secure-httpd     latest    <image_id>     a few seconds ago  143MB
```

## Step 6: Run the Container for Testing

```bash
docker run -d -p 8080:8080 -p 443:443 secure-httpd:latest
docker ps
```

## Step 7: Test the Web Server

```bash
curl http://localhost:8080
```

You should see the content of `index.html`.

## Step 8: Task Completion

Once verified, click on **FINISH** to submit the task.
This will trigger an automated build from your corrected Dockerfile.

```

---

Would you like me to generate this as a downloadable `command.md` file for you?
```
