# Kubernetes Secret Deployment Guide

## Project Overview

This guide demonstrates how to securely store license information using Kubernetes secrets and mount them in a pod for the Nautilus DevOps team.

## Prerequisites

- Access to `jump_host` with kubectl configured
- Kubernetes cluster access
- Secret key file `blog.txt` located at `/opt` on jump host

## Architecture

```
/opt/blog.txt (jump_host)
    ↓
Generic Secret (blog)
    ↓
Pod (secret-xfusion)
    ↓
Container Mount (/opt/demo)
```

## Components

### 1. Secret
- **Name**: `blog`
- **Type**: Generic Secret
- **Source**: `/opt/blog.txt`
- **Content**: License/password information

### 2. Pod
- **Name**: `secret-xfusion`
- **Container Name**: `secret-container-xfusion`
- **Image**: `fedora:latest`
- **Mount Path**: `/opt/demo`

## Deployment Steps

### Step 1: Create the Kubernetes Secret

Create a generic secret from the existing file:

```bash
kubectl create secret generic blog --from-file=/opt/blog.txt
```

**Verify secret creation:**
```bash
kubectl get secrets blog
kubectl describe secret blog
```

### Step 2: Create Pod Configuration

Create a file named `secret-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-xfusion
spec:
  containers:
  - name: secret-container-xfusion
    image: fedora:latest
    command: ["/bin/sleep"]
    args: ["infinity"]
    volumeMounts:
    - name: secret-volume
      mountPath: /opt/demo
      readOnly: true
  volumes:
  - name: secret-volume
    secret:
      secretName: blog
```

### Step 3: Deploy the Pod

```bash
kubectl apply -f secret-pod.yaml
```

### Step 4: Verify Deployment

**Check pod status:**
```bash
kubectl get pods secret-xfusion
```

**Wait for pod to be ready:**
```bash
kubectl wait --for=condition=Ready pod/secret-xfusion --timeout=60s
```

**Expected Output:**
```
NAME             READY   STATUS    RESTARTS   AGE
secret-xfusion   1/1     Running   0          30s
```

## Verification Commands

### Access the Container

```bash
kubectl exec -it secret-xfusion -c secret-container-xfusion -- /bin/bash
```

### Verify Secret Mount

**List files in mounted directory:**
```bash
kubectl exec -it secret-xfusion -c secret-container-xfusion -- ls -la /opt/demo
```

**View secret content:**
```bash
kubectl exec -it secret-xfusion -c secret-container-xfusion -- cat /opt/demo/blog.txt
```

## Quick Deployment Script

For rapid deployment, use this one-liner:

```bash
# Create secret
kubectl create secret generic blog --from-file=/opt/blog.txt

# Create and apply pod configuration
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secret-xfusion
spec:
  containers:
  - name: secret-container-xfusion
    image: fedora:latest
    command: ["/bin/sleep"]
    args: ["infinity"]
    volumeMounts:
    - name: secret-volume
      mountPath: /opt/demo
      readOnly: true
  volumes:
  - name: secret-volume
    secret:
      secretName: blog
EOF

# Wait and verify
kubectl wait --for=condition=Ready pod/secret-xfusion --timeout=60s
kubectl exec -it secret-xfusion -c secret-container-xfusion -- cat /opt/demo/blog.txt
```

## Troubleshooting

### Pod Not Starting

```bash
# Check pod events
kubectl describe pod secret-xfusion

# Check pod logs
kubectl logs secret-xfusion -c secret-container-xfusion
```

### Secret Not Found

```bash
# Verify secret exists
kubectl get secrets

# Check secret details
kubectl describe secret blog
```

### Mount Permission Issues

```bash
# Verify volume mounts
kubectl describe pod secret-xfusion | grep -A 5 Mounts

# Check container file system
kubectl exec -it secret-xfusion -c secret-container-xfusion -- ls -la /opt/
```

### Pod in ImagePullBackOff

```bash
# Check image pull status
kubectl describe pod secret-xfusion | grep -A 5 Events

# Verify image availability
kubectl get pod secret-xfusion -o jsonpath='{.spec.containers[0].image}'
```

## Cleanup

To remove all created resources:

```bash
# Delete pod
kubectl delete pod secret-xfusion

# Delete secret
kubectl delete secret blog

# Verify deletion
kubectl get pods,secrets
```

## Security Best Practices

1. **Read-Only Mount**: Secret is mounted as read-only to prevent modification
2. **Limited Access**: Only the specific pod has access to the secret
3. **No Base64 Exposure**: Secrets are automatically decoded when mounted
4. **RBAC**: Ensure proper role-based access control for secret management

## Key Configuration Details

| Component | Value |
|-----------|-------|
| Secret Name | `blog` |
| Secret Type | Generic (Opaque) |
| Pod Name | `secret-xfusion` |
| Container Name | `secret-container-xfusion` |
| Image | `fedora:latest` |
| Mount Path | `/opt/demo` |
| Volume Type | Secret Volume |
| Container Command | `sleep infinity` |

## Notes

- The container uses `sleep infinity` to remain running indefinitely
- Secret files are mounted as individual files within the target directory
- The filename from the source (`blog.txt`) is preserved in the mount path
- Validation may take time after clicking the Check button
- Ensure pod is in `Running` state before validation

## Support

For issues or questions, contact the Nautilus DevOps team.

---

**Last Updated**: November 2025  
**Version**: 1.0  
**Maintained By**: Nautilus DevOps Team
