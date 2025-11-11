# Iron Gallery Application - Kubernetes Deployment

## Overview
This repository contains Kubernetes manifests for deploying the Iron Gallery application with MariaDB database on a Kubernetes cluster.

## Architecture
The application consists of:
- **Iron Gallery**: A web-based gallery application (frontend)
- **Iron DB**: MariaDB database (backend)
- **Namespace**: Isolated environment for the application
- **Services**: ClusterIP for database, NodePort for frontend access

## Prerequisites
- Kubernetes cluster (v1.19+)
- kubectl configured to communicate with your cluster
- Sufficient cluster resources (CPU and memory)

## Components

### 1. Namespace
- **Name**: `iron-namespace-xfusion`
- **Purpose**: Isolates all Iron Gallery resources

### 2. Iron Gallery Deployment
- **Name**: `iron-gallery-deployment-xfusion`
- **Image**: `kodekloud/irongallery:2.0`
- **Replicas**: 1
- **Container**: `iron-gallery-container-xfusion`
- **Resource Limits**:
  - Memory: 100Mi
  - CPU: 50m
- **Volumes**:
  - `config`: Mounted at `/usr/share/nginx/html/data`
  - `images`: Mounted at `/usr/share/nginx/html/uploads`

### 3. Iron DB Deployment
- **Name**: `iron-db-deployment-xfusion`
- **Image**: `kodekloud/irondb:2.0`
- **Replicas**: 1
- **Container**: `iron-db-container-xfusion`
- **Environment Variables**:
  - `MYSQL_DATABASE`: database_apache
  - `MYSQL_ROOT_PASSWORD`: R00tP@ssw0rd#2024
  - `MYSQL_PASSWORD`: Us3rP@ssw0rd#2024
  - `MYSQL_USER`: ironuser
- **Volume**:
  - `db`: Mounted at `/var/lib/mysql`

### 4. Services

#### Iron DB Service
- **Name**: `iron-db-service-xfusion`
- **Type**: ClusterIP
- **Port**: 3306
- **Purpose**: Internal database access

#### Iron Gallery Service
- **Name**: `iron-gallery-service-xfusion`
- **Type**: NodePort
- **Port**: 80
- **NodePort**: 32678
- **Purpose**: External access to the gallery

## Deployment Instructions

### Quick Deploy
```bash
# Apply all resources
kubectl apply -f iron-gallery-kubernetes.yaml
```

### Step-by-Step Deployment

1. **Create the namespace**
   ```bash
   kubectl create namespace iron-namespace-xfusion
   ```

2. **Deploy the application**
   ```bash
   kubectl apply -f iron-gallery-kubernetes.yaml
   ```

3. **Verify deployments**
   ```bash
   kubectl get deployments -n iron-namespace-xfusion
   ```

4. **Check pod status**
   ```bash
   kubectl get pods -n iron-namespace-xfusion
   ```

5. **Verify services**
   ```bash
   kubectl get services -n iron-namespace-xfusion
   ```

## Verification Commands

### Check All Resources
```bash
kubectl get all -n iron-namespace-xfusion
```

### Check Pod Logs
```bash
# Iron Gallery logs
kubectl logs -n iron-namespace-xfusion -l run=iron-gallery

# Iron DB logs
kubectl logs -n iron-namespace-xfusion -l db=mariadb
```

### Describe Resources
```bash
# Describe gallery deployment
kubectl describe deployment iron-gallery-deployment-xfusion -n iron-namespace-xfusion

# Describe database deployment
kubectl describe deployment iron-db-deployment-xfusion -n iron-namespace-xfusion
```

### Wait for Pods to be Ready
```bash
kubectl wait --for=condition=ready pod -l run=iron-gallery -n iron-namespace-xfusion --timeout=300s
kubectl wait --for=condition=ready pod -l db=mariadb -n iron-namespace-xfusion --timeout=300s
```

## Accessing the Application

### Get Node IP
```bash
kubectl get nodes -o wide
```

### Access the Gallery
Open your browser and navigate to:
```
http://<NODE_IP>:32678
```

### Using kubectl port-forward (Alternative)
```bash
kubectl port-forward -n iron-namespace-xfusion svc/iron-gallery-service-xfusion 8080:80
```
Then access: `http://localhost:8080`

## Troubleshooting

### Pod Not Starting
```bash
# Check pod events
kubectl describe pod -n iron-namespace-xfusion <pod-name>

# Check logs
kubectl logs -n iron-namespace-xfusion <pod-name>
```

### Service Not Accessible
```bash
# Check service endpoints
kubectl get endpoints -n iron-namespace-xfusion

# Check if pods are running
kubectl get pods -n iron-namespace-xfusion -o wide
```

### Database Connection Issues
```bash
# Exec into the gallery pod
kubectl exec -it -n iron-namespace-xfusion <gallery-pod-name> -- /bin/bash

# Test database connectivity
nc -zv iron-db-service-xfusion 3306
```

### Check Resource Usage
```bash
kubectl top pods -n iron-namespace-xfusion
kubectl top nodes
```

## Cleanup

### Remove All Resources
```bash
kubectl delete -f iron-gallery-kubernetes.yaml
```

### Delete Namespace (removes everything)
```bash
kubectl delete namespace iron-namespace-xfusion
```

## Important Notes

1. **Database Connection**: The database and frontend are not connected yet. The installation page should appear if the deployment is successful.

2. **Passwords**: The database passwords in this configuration are examples. For production use, consider:
   - Using Kubernetes Secrets
   - Implementing proper password management
   - Using external secret management solutions

3. **Storage**: Currently using `emptyDir` volumes, which means data is lost when pods restart. For production:
   - Use PersistentVolumeClaims (PVC)
   - Configure proper backup strategies

4. **Resource Limits**: The gallery has conservative resource limits (100Mi memory, 50m CPU). Adjust based on actual usage.

5. **Security**: For production deployments:
   - Use NetworkPolicies
   - Implement RBAC
   - Use Pod Security Standards
   - Store secrets securely

## Configuration Changes

### Update Replicas
```bash
kubectl scale deployment iron-gallery-deployment-xfusion -n iron-namespace-xfusion --replicas=3
```

### Update Image
```bash
kubectl set image deployment/iron-gallery-deployment-xfusion -n iron-namespace-xfusion \
  iron-gallery-container-xfusion=kodekloud/irongallery:3.0
```

### Update Environment Variables
Edit the YAML file and reapply:
```bash
kubectl apply -f iron-gallery-kubernetes.yaml
```

## Monitoring

### Watch Pod Status
```bash
kubectl get pods -n iron-namespace-xfusion -w
```

### Stream Logs
```bash
kubectl logs -f -n iron-namespace-xfusion -l run=iron-gallery
```

## Support and Documentation

- Kubernetes Documentation: https://kubernetes.io/docs/
- kubectl Cheat Sheet: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

## Version History

- **v1.0**: Initial deployment with Iron Gallery 2.0 and Iron DB 2.0

---

**Maintained by**: Nautilus DevOps Team  
**Last Updated**: November 2025
