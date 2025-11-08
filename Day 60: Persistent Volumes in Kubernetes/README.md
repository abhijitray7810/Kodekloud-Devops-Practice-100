# Kubernetes Web Application Deployment with Persistent Storage

## Overview
This project deploys an Nginx web server on Kubernetes with persistent storage using PersistentVolume (PV) and PersistentVolumeClaim (PVC). The application is exposed via a NodePort service for external access.

## Architecture Components

### 1. PersistentVolume (pv-devops)
- **Name**: `pv-devops`
- **Storage Class**: `manual`
- **Capacity**: `5Gi`
- **Access Mode**: `ReadWriteOnce`
- **Volume Type**: `hostPath`
- **Host Path**: `/mnt/dba`

### 2. PersistentVolumeClaim (pvc-devops)
- **Name**: `pvc-devops`
- **Storage Class**: `manual`
- **Requested Storage**: `2Gi`
- **Access Mode**: `ReadWriteOnce`
- **Bound to**: `pv-devops`

### 3. Pod (pod-devops)
- **Name**: `pod-devops`
- **Container Name**: `container-devops`
- **Image**: `nginx:latest`
- **Volume Mount**: `/usr/share/nginx/html` (Nginx document root)
- **Labels**: `app: devops-web`

### 4. Service (web-devops)
- **Name**: `web-devops`
- **Type**: `NodePort`
- **Port**: `80`
- **NodePort**: `30008`
- **Selector**: `app: devops-web`

## Prerequisites
- Kubernetes cluster up and running
- `kubectl` configured to communicate with the cluster
- Directory `/mnt/dba` exists on the cluster node (pre-created)

## Deployment Instructions

### Step 1: Create the Resources
```bash
kubectl apply -f devops-deployment.yaml
```

### Step 2: Verify Deployment
```bash
# Check PersistentVolume
kubectl get pv pv-devops

# Check PersistentVolumeClaim
kubectl get pvc pvc-devops

# Check Pod
kubectl get pod pod-devops

# Check Service
kubectl get svc web-devops
```

### Expected Output
```
NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM
pv-devops   5Gi        RWO            Retain           Bound    default/pvc-devops

NAME         STATUS   VOLUME      CAPACITY   ACCESS MODES
pvc-devops   Bound    pv-devops   5Gi        RWO

NAME         READY   STATUS    RESTARTS   AGE
pod-devops   1/1     Running   0          27s

NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)
web-devops   NodePort    10.96.252.132   <none>        80:30008/TCP
```

## Accessing the Application

### Via NodePort
```bash
# Replace <node-ip> with your Kubernetes node IP
curl http://<node-ip>:30008
```

### From Within the Cluster
```bash
# Using Cluster IP
curl http://10.96.252.132:80

# Using Service DNS
curl http://web-devops.default.svc.cluster.local:80
```

## Testing and Validation

### Check Volume Mount
```bash
kubectl exec pod-devops -- df -h | grep nginx
kubectl exec pod-devops -- ls -la /usr/share/nginx/html
```

### View Pod Details
```bash
kubectl describe pod pod-devops
```

### Check Pod Logs
```bash
kubectl logs pod-devops
```

### Test Persistence
```bash
# Create a test file in the persistent volume
kubectl exec pod-devops -- sh -c 'echo "Hello from Persistent Volume" > /usr/share/nginx/html/test.html'

# Access the file
curl http://<node-ip>:30008/test.html

# Delete and recreate the pod
kubectl delete pod pod-devops
kubectl apply -f devops-deployment.yaml

# Verify the file still exists
curl http://<node-ip>:30008/test.html
```

## Troubleshooting

### Pod Not Starting
```bash
# Check pod events
kubectl describe pod pod-devops

# Check pod logs
kubectl logs pod-devops
```

### PVC Not Binding
```bash
# Check PVC status
kubectl describe pvc pvc-devops

# Check PV status
kubectl describe pv pv-devops

# Ensure storage class matches
kubectl get pv,pvc -o wide
```

### Service Not Accessible
```bash
# Check service endpoints
kubectl get endpoints web-devops

# Verify pod labels match service selector
kubectl get pod pod-devops --show-labels
```

## Cleanup

### Delete All Resources
```bash
kubectl delete service web-devops
kubectl delete pod pod-devops
kubectl delete pvc pvc-devops
kubectl delete pv pv-devops
```

### Or Delete Using the YAML File
```bash
kubectl delete -f devops-deployment.yaml
```

## File Structure
```
.
├── devops-deployment.yaml    # Main deployment manifest
└── README.md                 # This file
```

## Important Notes

1. **hostPath Volume**: The `hostPath` volume type is used for development/testing. For production, consider using network-attached storage (NFS, Ceph, etc.)

2. **Data Persistence**: Data stored in `/mnt/dba` on the host will persist even if the pod is deleted

3. **Access Mode**: `ReadWriteOnce` means the volume can be mounted as read-write by a single node

4. **NodePort Range**: NodePort services use ports in the range 30000-32767 by default

5. **Security**: In production environments, consider implementing NetworkPolicies, PodSecurityPolicies, and RBAC

## Maintenance

### Update Nginx Image
```bash
kubectl set image pod/pod-devops container-devops=nginx:1.24
```

### Scale (Convert to Deployment)
To scale this application, convert the Pod to a Deployment and change the access mode to `ReadWriteMany` or use `ReadOnlyMany` for multiple replicas.

## Support
For issues or questions, contact the Nautilus DevOps team.

## License
Internal Use - Nautilus DevOps Team
