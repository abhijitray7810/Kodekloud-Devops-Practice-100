# Task: Deploy Grafana on Kubernetes Cluster

## Step 1: Create Deployment YAML

```bash
vi grafana-deployment.yaml
````

Add the following content:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana-deployment-datacenter
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana
        ports:
        - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: grafana-service-datacenter
spec:
  type: NodePort
  selector:
    app: grafana
  ports:
  - port: 3000
    targetPort: 3000
    nodePort: 32000
```

---

## Step 2: Apply the Deployment and Service

```bash
kubectl apply -f grafana-deployment.yaml
```

---

## Step 3: Verify Deployment, Pod, and Service

```bash
kubectl get deployments grafana-deployment-datacenter
kubectl get pods -l app=grafana
kubectl get svc grafana-service-datacenter
```

Expected output:

```
NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
grafana-deployment-datacenter   1/1     1            1           33s

NAME                                             READY   STATUS    RESTARTS   AGE
grafana-deployment-datacenter-6746ccc7cd-gtrmq   1/1     Running   0          40s

NAME                         TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
grafana-service-datacenter   NodePort   10.96.100.214   <none>        3000:32000/TCP   47s
```

---

## Step 4: Get Node IP

```bash
kubectl get nodes -o wide
```

Example output:

```
NAME                      STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP
kodekloud-control-plane   Ready    control-plane   7m    v1.27.16  172.17.0.2    <none>
```

---

## Step 5: Access Grafana

Open in a browser:

```
http://172.17.0.2:32000
```

or test in terminal:

```bash
curl http://172.17.0.2:32000
```

If you see HTML output like:

```
<!DOCTYPE html><html><head><title>Grafana</title>...
```

✅ **Grafana is successfully deployed and accessible.**

---

```
```
