
### ✅ **commands.md**

```bash
# Step 1: Create a deployment with nginx:latest image and 3 replicas
kubectl create deployment nginx-deployment --image=nginx:latest --replicas=3

# Step 2: Delete the existing deployment (to reapply declaratively, optional if already created correctly)
kubectl delete deployment nginx-deployment

# Step 3: Create deployment manifest file
vi nginx-deployment.yaml
```

**nginx-deployment.yaml**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx-container
          image: nginx:latest
          ports:
            - containerPort: 80
```

```bash
# Step 4: Apply the deployment manifest
kubectl apply -f nginx-deployment.yaml

# Step 5: Create the service manifest
vi nginx-service.yaml
```

**nginx-service.yaml**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30011
```

```bash
# Step 6: Apply the service manifest
kubectl apply -f nginx-service.yaml

# Step 7: Verify deployment, pods, and service
kubectl get deployments
kubectl get pods
kubectl get svc
```

---

✅ **Result:**

* Deployment `nginx-deployment` created with 3 replicas.
* Service `nginx-service` of type `NodePort` created, exposing port `30011`.

---

Would you like me to provide this as a downloadable `.md` file?
