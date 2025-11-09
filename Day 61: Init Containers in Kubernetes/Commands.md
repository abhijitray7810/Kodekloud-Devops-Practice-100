# Kubernetes Init Container Deployment - ic-deploy-nautilus

## Step 1: Create the Deployment YAML file
```bash
vi ic-deploy-nautilus.yaml
````

### Paste the following content:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ic-deploy-nautilus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ic-nautilus
  template:
    metadata:
      labels:
        app: ic-nautilus
    spec:
      initContainers:
        - name: ic-msg-nautilus
          image: ubuntu:latest
          command: ["/bin/bash", "-c", "echo Init Done - Welcome to xFusionCorp Industries > /ic/media"]
          volumeMounts:
            - name: ic-volume-nautilus
              mountPath: /ic
      containers:
        - name: ic-main-nautilus
          image: ubuntu:latest
          command: ["/bin/bash", "-c", "while true; do cat /ic/media; sleep 5; done"]
          volumeMounts:
            - name: ic-volume-nautilus
              mountPath: /ic
      volumes:
        - name: ic-volume-nautilus
          emptyDir: {}
```

---

## Step 2: Apply the Deployment

```bash
kubectl apply -f ic-deploy-nautilus.yaml
```

---

## Step 3: Verify the Deployment

```bash
kubectl get deployments
kubectl get pods
```

---

## Step 4: Check Pod Logs (to confirm init message)

```bash
kubectl logs -f <pod-name>
```

Expected output:

```
Init Done - Welcome to xFusionCorp Industries
Init Done - Welcome to xFusionCorp Industries
...
```

---

## Step 5: Describe Pod (optional - to verify init container execution)

```bash
kubectl describe pod <pod-name>
```

You should see the init container `ic-msg-nautilus` completed successfully before the main container started.

---

✅ **Task Completed Successfully**
This setup uses:

* One init container (`ic-msg-nautilus`) to write a message to a shared volume
* One main container (`ic-main-nautilus`) that continuously reads the message
* A shared `emptyDir` volume (`ic-volume-nautilus`) for data exchange

```

---

Would you like me to include the **imperative kubectl commands version** (without YAML file creation) in the same `command.md` for quick testing?
```
