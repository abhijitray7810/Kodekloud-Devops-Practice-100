# Nautilus Static Website - Kubernetes Deployment

This project contains Kubernetes manifests for deploying a highly available and scalable static website using Nginx on a Kubernetes cluster.

## Overview

The deployment consists of:
- **Deployment**: Multiple Nginx replicas serving the static website
- **Service**: NodePort service for external access

## Architecture

- **Image**: nginx:latest
- **Replicas**: 3 (for high availability)
- **Service Type**: NodePort
- **External Port**: 30011

## Prerequisites

- Kubernetes cluster (running and accessible)
- kubectl configured on jump_host
- Appropriate permissions to create deployments and services

## Project Structure

```
.
├── nginx-deployment.yaml    # Deployment configuration
├── nginx-service.yaml       # Service configuration
└── README.md               # This file
```

## Deployment Files

### nginx-deployment.yaml
Creates a deployment with:
- Name: `nginx-deployment`
- Container: `nginx-container`
- Image: `nginx:latest`
- Replicas: 3
- Container Port: 80

### nginx-service.yaml
Creates a NodePort service with:
- Name: `nginx-service`
- Type: NodePort
- NodePort: 30011
- Target Port: 80

## Deployment Instructions

### Step 1: Apply the Deployment

```bash
kubectl apply -f nginx-deployment.yaml
```

### Step 2: Apply the Service

```bash
kubectl apply -f nginx-service.yaml
```

### Step 3: Verify the Deployment

```bash
# Check deployment status
kubectl get deployments nginx-deployment

# Check pods
kubectl get pods -l app=nginx

# Check service
kubectl get svc nginx-service
```

## Verification Commands

### Check Deployment Details
```bash
kubectl describe deployment nginx-deployment
```

### Check Pod Status
```bash
kubectl get pods -l app=nginx -o wide
```

### Check Service Details
```bash
kubectl describe svc nginx-service
```

### View Logs
```bash
# Get logs from all pods
kubectl logs -l app=nginx

# Get logs from a specific pod
kubectl logs <pod-name>
```

## Accessing the Website

Once deployed, the static website can be accessed via:

```
http://<node-ip>:30011
```

Where `<node-ip>` is the IP address of any node in your Kubernetes cluster.

### Get Node IPs
```bash
kubectl get nodes -o wide
```

## Scaling the Deployment

To scale the number of replicas:

```bash
# Scale to 5 replicas
kubectl scale deployment nginx-deployment --replicas=5

# Verify scaling
kubectl get pods -l app=nginx
```

## Updating the Deployment

To update the Nginx image version:

```bash
# Update to a specific version
kubectl set image deployment/nginx-deployment nginx-container=nginx:1.25

# Check rollout status
kubectl rollout status deployment/nginx-deployment

# View rollout history
kubectl rollout history deployment/nginx-deployment
```

## Rollback

If an update causes issues:

```bash
# Rollback to previous version
kubectl rollout undo deployment/nginx-deployment

# Rollback to specific revision
kubectl rollout undo deployment/nginx-deployment --to-revision=2
```

## Troubleshooting

### Pods Not Starting
```bash
# Check pod events
kubectl describe pod <pod-name>

# Check pod logs
kubectl logs <pod-name>
```

### Service Not Accessible
```bash
# Verify service endpoints
kubectl get endpoints nginx-service

# Check if pods are running
kubectl get pods -l app=nginx

# Test from within cluster
kubectl run test-pod --rm -it --image=busybox -- wget -O- http://nginx-service
```

### Image Pull Issues
```bash
# Check pod events for image pull errors
kubectl describe pod <pod-name>
```

## Cleanup

To remove all resources:

```bash
# Delete service
kubectl delete -f nginx-service.yaml

# Delete deployment
kubectl delete -f nginx-deployment.yaml

# Verify deletion
kubectl get all -l app=nginx
```

Or delete individually:

```bash
kubectl delete service nginx-service
kubectl delete deployment nginx-deployment
```

## High Availability Features

- **Multiple Replicas**: 3 replicas ensure the website remains available even if pods fail
- **Auto-healing**: Kubernetes automatically restarts failed pods
- **Load Balancing**: Service distributes traffic across all healthy pods
- **Rolling Updates**: Zero-downtime deployments when updating

## Security Considerations

- Consider using a specific Nginx version instead of `latest` for production
- Implement resource limits and requests
- Use network policies to restrict traffic
- Consider using Ingress instead of NodePort for production environments

## Best Practices

1. **Use Specific Image Tags**: Replace `latest` with specific versions in production
2. **Set Resource Limits**: Define CPU and memory limits for containers
3. **Health Checks**: Add liveness and readiness probes
4. **ConfigMaps**: Store Nginx configuration separately
5. **Secrets**: Use Kubernetes secrets for sensitive data

## Support

For issues or questions, contact the Nautilus DevOps team.

## License

Internal use only - Nautilus Team
