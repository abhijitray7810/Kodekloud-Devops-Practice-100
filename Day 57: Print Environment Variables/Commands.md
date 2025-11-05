# Kubernetes Pod with Environment Variables - Greeting Application

## Objective
Setup a Kubernetes pod that demonstrates environment variable usage for the Nautilus DevOps team's greeting application.

## Requirements
- Create a pod named `print-envars-greeting`
- Configure container with environment variables
- Print a greeting message using those variables
- Set restart policy to Never to avoid crash loop

## Solution

### Pod Configuration
The pod is configured with the following specifications:

- **Pod Name**: `print-envars-greeting`
- **Container Name**: `print-env-container`
- **Image**: `bash`
- **Restart Policy**: `Never`

### Environment Variables
Three environment variables are configured:

| Variable | Value |
|----------|-------|
| GREETING | Welcome to |
| COMPANY | xFusionCorp |
| GROUP | Group |

### Deployment Steps

1. **Create the YAML manifest file**:
```bash
vi print-envars-greeting.yaml
```

2. **Apply the configuration**:
```bash
kubectl apply -f print-envars-greeting.yaml
```

3. **Verify pod creation**:
```bash
kubectl get pods
```

4. **Check the output**:
```bash
kubectl logs -f print-envars-greeting
```

### Expected Output
```
Welcome to xFusionCorp Group
```

### Verification Results
```bash
thor@jumphost ~$ kubectl apply -f print-envars-greeting.yaml
pod/print-envars-greeting created

thor@jumphost ~$ kubectl get pods
NAME                    READY   STATUS      RESTARTS   AGE
print-envars-greeting   0/1     Completed   0          5s

thor@jumphost ~$ kubectl logs -f print-envars-greeting
Welcome to xFusionCorp Group
```

## Status
✅ **Task Completed Successfully**

The pod executed successfully, printed the greeting message, and completed without requiring restarts.
