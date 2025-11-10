# Kubernetes Secret and Pod Deployment

## Task Summary
The Nautilus DevOps team needs to:
1. Create a Kubernetes secret from an existing file `/opt/blog.txt`.
2. Deploy a pod that mounts this secret inside the container.

---

## Step 1: Create the Secret

Create a generic secret named **blog** using the file `/opt/blog.txt`:

```bash
kubectl create secret generic blog --from-file=/opt/blog.txt
````

Verify the secret creation:

```bash
kubectl get secrets
kubectl describe secret blog
```

---

## Step 2: Create the Pod Definition

Create a pod named **secret-xfusion** with:

* Container name: `secret-container-xfusion`
* Image: `fedora:latest`
* Command: `sleep 3600` (to keep it running)
* Mount the secret at `/opt/demo`

```bash
cat <<EOF > /tmp/pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-xfusion
spec:
  containers:
    - name: secret-container-xfusion
      image: fedora:latest
      command: ["sleep", "3600"]
      volumeMounts:
        - name: secret-volume
          mountPath: /opt/demo
  volumes:
    - name: secret-volume
      secret:
        secretName: blog
EOF
```

Apply the pod configuration:

```bash
kubectl apply -f /tmp/pod.yaml
```

---

## Step 3: Verify Pod Status

Check if the pod is running:

```bash
kubectl get pods
```

---

## Step 4: Verify Secret Mount Inside Pod

Exec into the running pod:

```bash
kubectl exec -it secret-xfusion -- /bin/bash
```

Inside the container, list and view the secret file:

```bash
ls /opt/demo
cat /opt/demo/blog.txt
```

---

## Step 5: Cleanup (Optional)

If you want to remove the resources after verification:

```bash
kubectl delete pod secret-xfusion
kubectl delete secret blog
```

---

✅ **End of File**

```

---

Would you like me to save this as a downloadable `command.md` file?
```
