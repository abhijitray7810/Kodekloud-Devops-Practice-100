

```bash
# Step 1: Create Namespace
kubectl create namespace iron-namespace-xfusion


# Step 2: Create Iron Gallery Deployment YAML
cat <<EOF > iron-gallery-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iron-gallery-deployment-xfusion
  namespace: iron-namespace-xfusion
  labels:
    run: iron-gallery
spec:
  replicas: 1
  selector:
    matchLabels:
      run: iron-gallery
  template:
    metadata:
      labels:
        run: iron-gallery
    spec:
      containers:
        - name: iron-gallery-container-xfusion
          image: kodekloud/irongallery:2.0
          resources:
            limits:
              memory: "100Mi"
              cpu: "50m"
          volumeMounts:
            - name: config
              mountPath: /usr/share/nginx/html/data
            - name: images
              mountPath: /usr/share/nginx/html/uploads
      volumes:
        - name: config
          emptyDir: {}
        - name: images
          emptyDir: {}
EOF

# Apply Iron Gallery Deployment
kubectl apply -f iron-gallery-deployment.yaml


# Step 3: Create Iron DB Deployment YAML
cat <<EOF > iron-db-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iron-db-deployment-xfusion
  namespace: iron-namespace-xfusion
  labels:
    db: mariadb
spec:
  replicas: 1
  selector:
    matchLabels:
      db: mariadb
  template:
    metadata:
      labels:
        db: mariadb
    spec:
      containers:
        - name: iron-db-container-xfusion
          image: kodekloud/irondb:2.0
          env:
            - name: MYSQL_DATABASE
              value: database_apache
            - name: MYSQL_ROOT_PASSWORD
              value: "ComplexRoot@123"
            - name: MYSQL_USER
              value: customuser
            - name: MYSQL_PASSWORD
              value: "UserPass@123"
          volumeMounts:
            - name: db
              mountPath: /var/lib/mysql
      volumes:
        - name: db
          emptyDir: {}
EOF

# Apply Iron DB Deployment
kubectl apply -f iron-db-deployment.yaml


# Step 4: Create Iron DB Service
cat <<EOF > iron-db-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: iron-db-service-xfusion
  namespace: iron-namespace-xfusion
spec:
  selector:
    db: mariadb
  ports:
    - protocol: TCP
      port: 3306
      targetPort: 3306
  type: ClusterIP
EOF

# Apply Iron DB Service
kubectl apply -f iron-db-service.yaml


# Step 5: Create Iron Gallery Service
cat <<EOF > iron-gallery-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: iron-gallery-service-xfusion
  namespace: iron-namespace-xfusion
spec:
  selector:
    run: iron-gallery
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 32678
  type: NodePort
EOF

# Apply Iron Gallery Service
kubectl apply -f iron-gallery-service.yaml


# Step 6: Verify All Resources
kubectl get all -n iron-namespace-xfusion


# Step 7: Access Iron Gallery App
# Use Node IP and NodePort 32678 to access the app in browser
# Example:
# curl http://<NodeIP>:32678
```

---


