# Day 52 – Lock-down App Servers with iptables (Load-Balancer Only)

## 🔐 Challenge
Nautilus DevOps team noticed port **6300** on every app server  
(`stapp01`, `stapp02`, `stapp03`) was **world-reachable** – big security hole.  
**Goal**: Accept traffic **ONLY from the internal load-balancer** (`stlb01`) and  
make the rule **persistent across reboots**.

---

## ✅ What success looks like
| Source        | Result on port 6300 |
|---------------|---------------------|
| stlb01        | OPEN                |
| Any other IP  | BLOCKED             |
| After reboot  | Still the same      |

---

## 🚀 One-script-fits-all solution
`firewall-lb-permanent.sh` – generic Bash (CentOS 7/8/9)

### Highlights
- Resolves LB hostname → IP automatically  
- Adds **ACCEPT** for LB_IP, **DROP** for 0.0.0.0/0  
- **Saves** rules to `/etc/sysconfig/iptables`  
- Restarts service → **survives reboot**
- ssh tony@stapp01, ssh tony@stapp02 , ssh tony@stapp03

- vi setup_firewall.sh
- chmod +x setup_firewall.sh
- ./setup_firewall.sh
- sudo iptables -L -n -v --line-numbers | grep 3001

---

## ⚙️  Usage
```bash
# 1. copy to target server
scp firewall-lb-permanent.sh user@stapp0X:~

# 2. run (needs sudo)
ssh user@stapp0X
chmod +x firewall-lb-permanent.sh
sudo ./firewall-lb-permanent.sh
```

Repeat for **stapp01**, **stapp02**, **stapp03** – **zero changes** in script.

---

## 🔍 Quick verify
```bash
# from jumphost – should return BLOCKED
for h in stapp01 stapp02 stapp03; do
  echo -n "$h: "
  timeout 2 nc -vz $h 6300 2>&1 |grep -q open && echo OPEN || echo BLOCKED
done
```

---

## 📁 Repo structure
```
day52-iptables-lb-lockdown/
├── firewall-lb-permanent.sh   # runnable script
├── README.md                  # this file
└── assets/                    # screenshots (before vs after)
    ├── before.png
    └── after.png
```

---

## 📄 License
MIT – feel free to use in your own labs / production templates.

---




**Happy hacking & stay secure!** 🔒
```

```bash
#!/bin/bash

# Apache port
APP_PORT=3001

# Load Balancer Hostname
LB_HOST="stlb01"

# Paths
YUM=/usr/bin/yum
IPTABLES=/usr/sbin/iptables
SERVICE=/usr/sbin/service
SYSTEMCTL=/usr/bin/systemctl
GETENT=/usr/bin/getent
AWK=/usr/bin/awk

echo "[INFO] Installing iptables..."
$YUM install -y iptables iptables-services

echo "[INFO] Enabling iptables service..."
$SYSTEMCTL enable iptables
$SYSTEMCTL start iptables

echo "[INFO] Flushing old rules..."
$IPTABLES -F

echo "[INFO] Getting Load Balancer IP..."
LB_IP=$($GETENT hosts $LB_HOST | $AWK '{print $1}')
if [ -z "$LB_IP" ]; then
  echo "[ERROR] Could not resolve IP for $LB_HOST"
  exit 1
fi
echo "[INFO] LB Host: $LB_HOST, IP: $LB_IP"

echo "[INFO] Adding firewall rules..."
# Allow traffic from LB host
$IPTABLES -A INPUT -p tcp -s $LB_IP --dport $APP_PORT -j ACCEPT
# Block everyone else
$IPTABLES -A INPUT -p tcp --dport $APP_PORT -j DROP

echo "[INFO] Saving firewall rules..."
$SERVICE iptables save
$SYSTEMCTL restart iptables

echo "[INFO] Firewall rules applied successfully!"
$IPTABLES -L -n -v --line-numbers | grep $APP_PORT
```


