#!/bin/bash

# SSH into App Server 1 is manual, so start from server

# 1. Install Nginx
sudo yum install -y epel-release
sudo yum install -y nginx

# 2. Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# 3. Move SSL certificate and key
sudo mkdir -p /etc/nginx/ssl
sudo mv /tmp/nautilus.crt /etc/nginx/ssl/
sudo mv /tmp/nautilus.key /etc/nginx/ssl/
sudo chmod 600 /etc/nginx/ssl/nautilus.key

# 4. Backup default config and copy custom nginx.conf
sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
sudo cp ./nginx.conf /etc/nginx/conf.d/ssl.conf

# 5. Create index.html
echo "Welcome!" | sudo tee /usr/share/nginx/html/index.html

# 6. Test Nginx configuration and restart
sudo nginx -t
sudo systemctl restart nginx

# 7. Test from this server (optional)
curl -Ik https://localhost
