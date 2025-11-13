Here’s the **`command.md`** file containing all the necessary Kubernetes commands to complete the Redis deployment task 👇

---

## command.md

```bash
# Step 1: Create ConfigMap for Redis configuration
kubectl create configmap my-redis-config --from-literal=redis-config="maxmemory 2mb"

# Step 2: Create Redis Deployment YAML file
cat <<EOF > redis-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
  labels:
    app: redis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
        - name: redis-container
          image: redis:alpine
          ports:
            - containerPort: 6379
          resources:
            requests:
              cpu: "1"
          volumeMounts:
            - name: data
              mountPath: /redis-master-data
            - name: redis-config
              mountPath: /redis-master
              readOnly: true
      volumes:
        - name: data
          emptyDir: {}
        - name: redis-config
          configMap:
            name: my-redis-config
            items:
              - key: redis-config
                path: redis.conf
EOF

# Step 3: Apply the deployment
kubectl apply -f redis-deployment.yaml

# Step 4: Verify the deployment
kubectl get deployments
kubectl get pods
kubectl describe deployment redis-deployment

# Step 5: (Optional) Check logs of Redis pod
kubectl logs -l app=redis
```

---

Would you like me to add a **Service definition** section (for internal Redis access via ClusterIP)?
