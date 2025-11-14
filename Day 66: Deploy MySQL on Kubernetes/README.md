# MySQL Kubernetes Deployment

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

A production-ready MySQL database deployment on Kubernetes with persistent storage, secret management, and NodePort service exposure.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Components](#components)
- [Deployment Guide](#deployment-guide)
- [Verification](#verification)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This project demonstrates a complete MySQL database deployment on Kubernetes, featuring:

- **Persistent Storage**: 250Mi PersistentVolume and PersistentVolumeClaim
- **Secret Management**: Secure credential storage using Kubernetes Secrets
- **Service Exposure**: NodePort service on port 30007
- **Environment Configuration**: Dynamic environment variable injection
- **Production Ready**: Best practices for database deployment in Kubernetes

## 🏗️ Architecture
![image](https://github.com/abhijitray7810/mysql-kubernetes-deployment/blob/47993a05d5521ca5aedec9931610fca5c1936521/docs/Kubernetes%20MySQL%20Deployment%20Architecture.png)
## ✅ Prerequisites

- Kubernetes cluster (v1.19+)
- `kubectl` CLI tool configured
- Access to Kubernetes cluster with appropriate permissions
- Basic understanding of Kubernetes concepts

## 🚀 Quick Start

### One-Command Deployment

```bash
kubectl apply -f mysql-deployment.yaml
```

### Step-by-Step Deployment

```bash
# Clone the repository
git clone https://github.com/yourusername/mysql-kubernetes-deployment.git
cd mysql-kubernetes-deployment

# Deploy using individual manifests
kubectl apply -f manifests/secrets.yaml
kubectl apply -f manifests/pv-pvc.yaml
kubectl apply -f manifests/deployment.yaml
kubectl apply -f manifests/service.yaml

# Verify deployment
kubectl get all
```

## 📁 Project Structure

```
mysql-kubernetes-deployment/
├── README.md                      # This file
├── mysql-deployment.yaml          # Complete deployment (all-in-one)
├── manifests/                     # Individual manifest files
│   ├── secrets.yaml              # Kubernetes secrets
│   ├── pv-pvc.yaml               # Storage configuration
│   ├── deployment.yaml           # MySQL deployment
│   └── service.yaml              # NodePort service
├── docs/
│   └── deployment-guide.md       # Detailed deployment guide
└── screenshots/                   # Deployment verification images
```

## 🔧 Components

### 1. Secrets (3)
- **mysql-root-pass**: Root password
- **mysql-user-pass**: User credentials (username + password)
- **mysql-db-url**: Database name

### 2. Storage
- **PersistentVolume**: 250Mi capacity with hostPath
- **PersistentVolumeClaim**: 250Mi request bound to PV

### 3. Deployment
- **Image**: mysql:5.7
- **Replicas**: 1
- **Mount Path**: /var/lib/mysql
- **Environment Variables**: Injected from secrets

### 4. Service
- **Type**: NodePort
- **Port**: 3306
- **NodePort**: 30007

## 📖 Deployment Guide

See [detailed deployment guide](docs/deployment-guide.md) for comprehensive instructions.

### Basic Deployment Steps

1. **Create Secrets**
   ```bash
   kubectl apply -f manifests/secrets.yaml
   ```

2. **Setup Storage**
   ```bash
   kubectl apply -f manifests/pv-pvc.yaml
   ```

3. **Deploy MySQL**
   ```bash
   kubectl apply -f manifests/deployment.yaml
   ```

4. **Expose Service**
   ```bash
   kubectl apply -f manifests/service.yaml
   ```

## ✔️ Verification

### Check All Resources

```bash
# Check secrets
kubectl get secrets

# Check storage
kubectl get pv
kubectl get pvc

# Check deployment and pods
kubectl get deployments
kubectl get pods

# Check service
kubectl get svc mysql
```

### Connect to MySQL

```bash
# Get node IP
kubectl get nodes -o wide

# Connect via NodePort
mysql -h <NODE_IP> -P 30007 -u kodekloud_joy -pGyQkFRVNr3 kodekloud_db10

# Or use port-forward for local access
kubectl port-forward svc/mysql 3306:3306
mysql -h 127.0.0.1 -P 3306 -u kodekloud_joy -pGyQkFRVNr3 kodekloud_db10
```

### Check Logs

```bash
# View MySQL logs
kubectl logs -f deployment/mysql-deployment

# Describe pod for details
kubectl describe pod <pod-name>
```

## ⚙️ Configuration

### Environment Variables

| Variable | Source | Description |
|----------|--------|-------------|
| `MYSQL_ROOT_PASSWORD` | mysql-root-pass | Root user password |
| `MYSQL_DATABASE` | mysql-db-url | Initial database name |
| `MYSQL_USER` | mysql-user-pass | Application user |
| `MYSQL_PASSWORD` | mysql-user-pass | Application user password |

### Default Credentials

- **Root Password**: YUIidhb667
- **Database**: kodekloud_db10
- **Username**: kodekloud_joy
- **User Password**: GyQkFRVNr3

> ⚠️ **Security Note**: Change these credentials in production environments!

### Storage Configuration

- **Capacity**: 250Mi
- **Access Mode**: ReadWriteOnce
- **Reclaim Policy**: Retain
- **Storage Class**: Dynamic provisioning (default)

## 🔍 Troubleshooting

### Pod Not Starting

```bash
# Check pod status
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>

# Common issues:
# - PVC not bound
# - Secret not found
# - Image pull errors
```

### PVC Not Binding

```bash
# Check PVC status
kubectl describe pvc mysql-pv-claim

# Check available PVs
kubectl get pv

# Verify storage class
kubectl get storageclass
```

### Connection Issues

```bash
# Verify service endpoints
kubectl get endpoints mysql

# Check if pod is running
kubectl get pods -l app=mysql

# Test internal connectivity
kubectl run -it --rm mysql-client --image=mysql:5.7 --restart=Never -- \
  mysql -h mysql -u kodekloud_joy -pGyQkFRVNr3 kodekloud_db10
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [.gitignore] file for details.

## 👤 Author

**Your Name**
- LinkedIn: [ LinkedIn Profile](https://www.linkedin.com/in/abhijit-ray-336442295)
- GitHub: [github](https://github.com/abhijitray7810)

## 🌟 Acknowledgments

- Kubernetes Documentation
- MySQL Docker Official Images
- KodeKloud DevOps Training

---

⭐ If you find this project helpful, please consider giving it a star!

**Tags**: `kubernetes` `mysql` `docker` `devops` `k8s` `persistent-storage` `secrets-management` `database` `deployment`
