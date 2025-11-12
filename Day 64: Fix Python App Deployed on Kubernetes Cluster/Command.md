# Kubernetes Python App Deployment Fix - Commands

## Initial Troubleshooting Commands

### Check Current Deployment
```bash
kubectl get deployment python-deployment-xfusion -o yaml
```

### Check Services
```bash
kubectl get service -l app=python-deployment-xfusion -o yaml
```

### Check Pods
```bash
kubectl get pods -l app=python-deployment-xfusion
kubectl describe pods -l app=python-deployment-xfusion
```

## Fix Deployment Issues

### Delete Existing Broken Deployment
```bash
kubectl delete deployment python-deployment-xfusion
```

### Create Fixed Deployment Configuration
```bash
cat > fixed-deployment.yaml << EOF
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
EOF
```

### Apply Fixed Deployment
```bash
kubectl apply -f fixed-deployment.yaml
```

## Create Service Configuration

### Create Service YAML
```bash
cat > python-service.yaml << EOF
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
EOF
```

### Apply Service
```bash
kubectl apply -f python-service.yaml
```

## Alternative Quick Fix Commands

### Delete and Recreate Deployment (One-liner)
```bash
kubectl delete deployment python-deployment-xfusion && \
kubectl create deployment python-deployment-xfusion --image=poroko/flask-demo-app --port=5000 --dry-run=client -o yaml > deployment.yaml && \
sed -i 's/app: python-deployment-xfusion/app: python-deployment-xfusion/g' deployment.yaml && \
kubectl apply -f deployment.yaml
```

### Create Service (One-liner)
```bash
kubectl expose deployment python-deployment-xfusion --name=python-service-xfusion --type=NodePort --port=80 --target-port=5000 --node-port=32345
```

## Verification Commands

### Check Deployment Status
```bash
kubectl get deployment python-deployment-xfusion
```

### Check Pod Status
```bash
kubectl get pods -l app=python-deployment-xfusion
kubectl describe pods -l app=python-deployment-xfusion
```

### Check Service Status
```bash
kubectl get service python-service-xfusion
kubectl describe service python-service-xfusion
```

### Check Pod Logs
```bash
kubectl logs -l app=python-deployment-xfusion
```

## Testing Commands

### Get Node Information
```bash
kubectl get nodes -o wide
```

### Test Application Access
```bash
curl http://<NODE_IP>:32345
```

### Port Forward for Testing
```bash
kubectl port-forward service/python-service-xfusion 8080:80
curl http://localhost:8080
```

## Cleanup Commands (Optional)

### Delete Deployment and Service
```bash
kubectl delete deployment python-deployment-xfusion
kubectl delete service python-service-xfusion
```

### Delete Configuration Files
```bash
rm -f fixed-deployment.yaml python-service.yaml deployment.yaml
```

## Key Issues Fixed

1. **Wrong Image Name**: Changed from `poroko/flask-app-demo` to `poroko/flask-demo-app`
2. **Label Mismatch**: Fixed selector and template labels to match
3. **Missing Service**: Created NodePort service with correct configuration
4. **Port Configuration**: Set targetPort to 5000 (Flask default) and nodePort to 32345

## Expected Outcome

After running these commands, the application should be:
- Running in a pod with correct image
- Accessible via NodePort 32345
- Routing traffic to Flask app on port 5000
- Properly load balanced by the service
```
