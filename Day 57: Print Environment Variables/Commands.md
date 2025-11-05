# Task: Create a pod to print environment variables greeting

## Step 1: Create the YAML definition file
```bash
vi print-envars-greeting.yaml
````

## Step 2: Add the following content

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: print-envars-greeting
spec:
  containers:
    - name: print-env-container
      image: bash
      command: ["/bin/sh", "-c", 'echo "$(GREETING) $(COMPANY) $(GROUP)"']
      env:
        - name: GREETING
          value: "Welcome to"
        - name: COMPANY
          value: "xFusionCorp"
        - name: GROUP
          value: "Group"
  restartPolicy: Never
```

## Step 3: Create the pod

```bash
kubectl apply -f print-envars-greeting.yaml
```

## Step 4: Verify the pod status

```bash
kubectl get pods
```

(Expected STATUS: `Completed`)

## Step 5: View the output from the pod logs

```bash
kubectl logs -f print-envars-greeting
```

### ✅ Expected Output:

```
Welcome to xFusionCorp Group
```

```

---

Would you like me to include a **one-line kubectl run** command version (without YAML file) as a shortcut too?
```
