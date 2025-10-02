# Nginx + PHP-FPM 8.2 Deployment on stapp02

This repository documents the steps to install and configure **Nginx** with **PHP-FPM 8.2** on `stapp02` server for hosting PHP-based applications. The setup uses a **Unix socket** for communication between Nginx and PHP-FPM.

---

## Requirements

- CentOS Stream 9
- Nginx
- PHP 8.2 (PHP-FPM, PHP CLI, PHP MySQL)
- Application files under `/var/www/html`:
  - `index.php`
  - `info.php`
- PHP-FPM socket: `/var/run/php-fpm/default.sock`
- Nginx listening on port `8093`

---

## Installation Steps

### 1. Enable EPEL & Remi Repositories
```bash
sudo dnf install -y epel-release
sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm
sudo dnf module reset php -y
sudo dnf module enable php:remi-8.2 -y
````

### 2. Install Packages

```bash
sudo dnf install -y php php-cli php-fpm php-mysqlnd nginx
```

---

## PHP-FPM Configuration

1. Edit the PHP-FPM pool configuration:

```bash
sudo vi /etc/php-fpm.d/www.conf
```

2. Ensure the following lines exist and **remove any other conflicting `listen` lines**:

```
listen = /var/run/php-fpm/default.sock
listen.owner = nginx
listen.group = nginx
listen.mode = 0660
```

> **Note:** Keep other `php_value` and `php_admin_value` lines as-is (error logs, session paths, etc.).

3. Create the PHP-FPM run directory:

```bash
sudo mkdir -p /var/run/php-fpm
sudo chown -R nginx:nginx /var/run/php-fpm
```

4. Test PHP-FPM configuration:

```bash
sudo php-fpm -t
```

---

## Nginx Configuration

1. Create a new configuration file for stapp02:

```bash
sudo vi /etc/nginx/conf.d/stapp02.conf
```

2. Add the following configuration:

```nginx
server {
    listen 8093;
    root /var/www/html;
    index index.php index.html;

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php-fpm/default.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

---

## Start Services

```bash
sudo systemctl enable php-fpm --now
sudo systemctl enable nginx --now
```

Verify status:

```bash
systemctl status php-fpm
systemctl status nginx
```

---

## Validation Checklist

* PHP-FPM version:

```bash
php-fpm -v
# Must show PHP 8.2.x
```

* Socket exists and ownership is correct:

```bash
ls -l /var/run/php-fpm/default.sock
# Must show: nginx:nginx
```

* Nginx configuration:

```bash
grep "fastcgi_pass" /etc/nginx/conf.d/stapp02.conf
# Must show: fastcgi_pass unix:/var/run/php-fpm/default.sock;
```

* Test the application:

```bash
curl http://stapp02:8093/index.php
# Should return: Welcome to xFusionCorp Industries!
```

---

## Notes

* Make sure the firewall allows port 8093:

```bash
sudo firewall-cmd --add-port=8093/tcp --permanent
sudo firewall-cmd --reload
```

* The `/var/run/php-fpm` directory is recreated after reboot (tmpfs). PHP-FPM will recreate the socket automatically.

---

This setup ensures **Nginx + PHP-FPM 8.2** communicate correctly via a Unix socket, and your PHP application is served securely on port `8093`.

```
Do you want me to do that next?
```
