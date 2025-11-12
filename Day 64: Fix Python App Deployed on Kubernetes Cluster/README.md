# Kubernetes Python Flask App Deployment Fix

## Problem Description

A Python Flask application deployment on Kubernetes was failing due to multiple configuration issues. The deployment named `python-deployment-xfusion` using the `poroko/flask-demo-app` image was not starting properly, and the application was inaccessible.

## Root Cause Analysis

### Issues Identified:

1. **Incorrect Image Name**: 
   - Deployment was using `poroko/flask-app-demo` (non-existent)
   - Correct image: `poroko/flask-demo-app`

2. **Label Mismatch**:
   - Deployment selector used `app: python_app`
   - Service was looking for `app: python-deployment-xfusion`
   - This caused service-to-pod communication failure

3. **Missing Service**:
   - No Kubernetes service was created to expose the application
   - No NodePort configuration for external access

4. **Port Configuration**:
   - Flask app runs on port 5000 by default
   - No proper port mapping between service and containers

## Solution

### Fixed Components:

1. **Deployment**:
   - Correct image: `poroko/flask-demo-app`
   - Proper label selectors: `app: python-deployment-xfusion`
   - Container port exposed: 5000

2. **Service**:
   - Type: NodePort
   - Target Port: 5000 (Flask app port)
   - NodePort: 32345 (external access port)
   - Port: 80 (internal service port)

### Architecture Overview

```
External User → NodePort 32345 → Service (port 80) → Pod (port 5000) → Flask App
```

## Prerequisites

- Kubernetes cluster running
- `kubectl` configured and authenticated
- Access to jump_host with kubectl access

## Quick Fix Deployment

### Method 1: Complete Recreate (Recommended)

```bash
# Delete broken deployment
kubectl delete deployment python-deployment-xfusion

# Create fixed deployment
kubectl apply -f fixed-deployment.yaml

# Create service
kubectl apply -f python-service.yaml
```

### Method 2: One-liner Approach

```bash
kubectl delete deployment python-deployment-xfusion && \
kubectl create deployment python-deployment-xfusion --image=poroko/flask-demo-app --port=5000 && \
kubectl expose deployment python-deployment-xfusion --name=python-service-xfusion --type=NodePort --port=80 --target-port=5000 --node-port=32345
```

## Configuration Files

### fixed-deployment.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: python-deployment-xfusion
spec:
  replicas: 1
  selector:
    matchLabels:
      app: python-deployment-xfusion
  template:
    metadata:
      labels:
        app: python-deployment-xfusion
    spec:
      containers:
      - name: python-container-xfusion
        image: poroko/flask-demo-app
        ports:
        - containerPort: 5000
```

### python-service.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: python-service-xfusion
  labels:
    app: python-deployment-xfusion
spec:
  type: NodePort
  selector:
    app: python-deployment-xfusion
  ports:
  - port: 80
    targetPort: 5000
    nodePort: 32345
```

## Verification Steps

1. **Check Deployment Status**:
   ```bash
   kubectl get deployment python-deployment-xfusion
   ```

2. **Check Pod Status**:
   ```bash
   kubectl get pods -l app=python-deployment-xfusion
   ```

3. **Check Service Status**:
   ```bash
   kubectl get service python-service-xfusion
   ```

4. **Test Application Access**:
   ```bash
   # Get node IP
   kubectl get nodes -o wide
   
   # Test application
   curl http://<NODE_IP>:32345
   ```

## Troubleshooting

### Common Issues and Solutions:

1. **Image Pull Errors**:
   - Verify image name: `poroko/flask-demo-app`
   - Check network connectivity to container registry

2. **Pods Not Starting**:
   ```bash
   kubectl describe pods -l app=python-deployment-xfusion
   kubectl logs -l app=python-deployment-xfusion
   ```

3. **Service Not Routing**:
   - Verify label selectors match between service and pods
   - Check service endpoints: `kubectl get endpoints python-service-xfusion`

4. **Port Access Issues**:
   - Verify NodePort range (30000-32767)
   - Check firewall rules for node ports

### Diagnostic Commands:

```bash
# Check all resources
kubectl get all -l app=python-deployment-xfusion

# Detailed pod information
kubectl describe pod <pod-name>

# Check service endpoints
kubectl get endpoints python-service-xfusion

# Test internal service access
kubectl port-forward service/python-service-xfusion 8080:80
curl http://localhost:8080
```

## Expected Results

After successful deployment:

- ✅ Deployment shows 1/1 replicas ready
- ✅ Pod status shows "Running"
- ✅ Service is available with NodePort 32345
- ✅ Application responds on `http://<node-ip>:32345`
- ✅ All components have matching labels

## Security Considerations

- NodePort 32345 is exposed externally
- Consider using Ingress controller for production
- Implement network policies if needed
- Use secrets for sensitive configuration

## Maintenance

### Scaling the Application:
```bash
kubectl scale deployment python-deployment-xfusion --replicas=3
```

### Updating the Application:
```bash
kubectl set image deployment/python-deployment-xfusion python-container-xfusion=poroko/flask-demo-app:latest
```

### Cleanup:
```bash
kubectl delete deployment python-deployment-xfusion
kubectl delete service python-service-xfusion
```

## Support

For additional troubleshooting, check:
- Kubernetes logs: `kubectl logs <pod-name>`
- Events: `kubectl get events --sort-by=.metadata.creationTimestamp`
- Service details: `kubectl describe service python-service-xfusion`
```
