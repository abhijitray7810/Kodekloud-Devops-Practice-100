# 🚀 Kubernetes Task — Web Application Deployment with Persistent Volume (Nautilus DevOps)

This document lists all commands required to:
- Create PV, PVC, Pod, and Service
- Verify resources
- Fix Nginx 403 Forbidden issue
---

## 1️⃣ Create Persistent Volume (pv-devops)

```bash
cat <<EOF > pv-devops.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-devops
spec:
  storageClassName: manual
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/dba
EOF

kubectl apply -f pv-devops.yaml
````

---

## 2️⃣ Create Persistent Volume Claim (pvc-devops)

```bash
cat <<EOF > pvc-devops.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-devops
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
EOF

kubectl apply -f pvc-devops.yaml
```

---

## 3️⃣ Create Pod (pod-devops)

```bash
cat <<EOF > pod-devops.yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-devops
  labels:
    app: devops
spec:
  containers:
  - name: container-devops
    image: nginx:latest
    ports:
    - containerPort: 80
    volumeMounts:
    - mountPath: /usr/share/nginx/html
      name: devops-storage
  volumes:
  - name: devops-storage
    persistentVolumeClaim:
      claimName: pvc-devops
EOF

kubectl apply -f pod-devops.yaml
```

---

## 4️⃣ Create Service (web-devops)

```bash
cat <<EOF > web-devops-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: web-devops
spec:
  type: NodePort
  selector:
    app: devops
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30008
EOF

kubectl apply -f web-devops-service.yaml
```

---

## 5️⃣ Verify Resources

```bash
kubectl get pv
kubectl get pvc
kubectl get pod -o wide
kubectl get svc
kubectl describe svc web-devops | grep Endpoints
```

✅ Expected output:

```
pv-devops      Bound
pvc-devops     Bound
pod-devops     Running
web-devops     NodePort   80:30008/TCP
Endpoints:     10.244.x.x:80
```

---

## 6️⃣ Fix 403 Forbidden Issue (Empty Nginx Directory)

Create a simple HTML file inside the mounted volume:

```bash
kubectl exec pod-devops -- /bin/sh -c 'echo "Welcome to Nautilus DevOps Web Server!" > /usr/share/nginx/html/index.html'
```

Verify file:

```bash
kubectl exec pod-devops -- ls -l /usr/share/nginx/html
```

---

## 7️⃣ Test the Web Server

### From Jump Host

```bash
kubectl get nodes -o wide
# Note INTERNAL-IP (example: 172.17.0.2)
curl http://172.17.0.2:30008
```

### From Inside Cluster

```bash
kubectl run test-pod --image=busybox:1.28 -it --rm --restart=Never -- /bin/sh
/ # wget -qO- http://web-devops:80
```

Expected output:

```
Welcome to Nautilus DevOps Web Server!
```

---

## ✅ Cleanup (Optional)

```bash
kubectl delete pod pod-devops
kubectl delete svc web-devops
kubectl delete pvc pvc-devops
kubectl delete pv pv-devops
```

---

**All steps complete.**
Your web server is now running successfully with Persistent Volume storage and NodePort access on **port 30008**. 🎉

```

---

Would you like me to combine these YAMLs and commands into a **single `.zip` file** so you can directly upload and apply them (`kubectl apply -f all.yaml`)?
```

