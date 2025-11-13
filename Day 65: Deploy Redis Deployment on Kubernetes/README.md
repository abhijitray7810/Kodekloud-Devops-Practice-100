# Redis Kubernetes Deployment

## Overview

This repository contains Kubernetes manifests for deploying Redis with custom configuration for the Nautilus application development team. The deployment uses in-memory caching to improve database service performance.

## Architecture

The deployment consists of:
- **ConfigMap**: Stores Redis configuration with memory limits
- **Deployment**: Manages Redis pod with alpine-based image
- **Volumes**: EmptyDir for data storage and ConfigMap for configuration

## Prerequisites

- Kubernetes cluster (configured and accessible)
- `kubectl` utility configured to work with the cluster
- Appropriate permissions to create ConfigMaps and Deployments

## Components

### 1. ConfigMap (`my-redis-config`)
- **Purpose**: Stores Redis configuration parameters
- **Configuration**: Sets maximum memory limit to 2MB
- **Key**: `redis-config`

### 2. Deployment (`redis-deployment`)
- **Image**: `redis:alpine`
- **Replicas**: 1
- **Container Name**: `redis-container`
- **Port**: 6379
- **CPU Request**: 1 CPU

### 3. Volumes
- **data**: EmptyDir volume mounted at `/redis-master-data`
- **redis-config**: ConfigMap volume mounted at `/redis-master`

## Deployment Instructions

### Step 1: Clone or Download the Configuration

Ensure you have the `redis-deployment.yaml` file available.

### Step 2: Deploy to Kubernetes

```bash
# Apply the configuration
kubectl apply -f redis-deployment.yaml
```

Expected output:
```
configmap/my-redis-config created
deployment.apps/redis-deployment created
```

### Step 3: Verify Deployment

#### Check ConfigMap
```bash
kubectl get configmap my-redis-config
kubectl describe configmap my-redis-config
```

#### Check Deployment Status
```bash
kubectl get deployment redis-deployment
kubectl rollout status deployment/redis-deployment
```

#### Check Pod Status
```bash
kubectl get pods -l app=redis
```

Expected output:
```
NAME                                READY   STATUS    RESTARTS   AGE
redis-deployment-xxxxxxxxxx-xxxxx   1/1     Running   0          30s
```

## Verification and Testing

### 1. Check Pod Logs
```bash
# Get pod name
POD_NAME=$(kubectl get pods -l app=redis -o jsonpath='{.items[0].metadata.name}')

# View logs
kubectl logs $POD_NAME
```

### 2. Access Redis CLI
```bash
# Execute interactive shell
kubectl exec -it $POD_NAME -- redis-cli
```

### 3. Test Redis Commands
Inside the Redis CLI:
```redis
# Test connectivity
ping

# Check maxmemory configuration
config get maxmemory

# Set a test key
set testkey "Hello from Nautilus"

# Get the test key
get testkey

# Exit
exit
```

### 4. Verify Volume Mounts
```bash
kubectl exec -it $POD_NAME -- sh

# Inside the container
ls -la /redis-master-data
ls -la /redis-master
cat /redis-master/redis-config

exit
```

### 5. Check Resource Allocation
```bash
kubectl describe pod $POD_NAME | grep -A 5 "Requests"
```

## Configuration Details

### ConfigMap Content
```yaml
maxmemory 2mb
```

### Resource Requests
- **CPU**: 1 core requested

### Network
- **Container Port**: 6379 (Redis default port)

## Troubleshooting

### Pod Not Starting

1. Check pod status:
```bash
kubectl describe pod $POD_NAME
```

2. Check events:
```bash
kubectl get events --sort-by=.metadata.creationTimestamp
```

### ConfigMap Issues

Verify ConfigMap exists and contains correct data:
```bash
kubectl get configmap my-redis-config -o yaml
```

### Resource Issues

Check if cluster has sufficient resources:
```bash
kubectl describe nodes
```

### Image Pull Issues

Ensure the cluster can pull the `redis:alpine` image:
```bash
kubectl describe pod $POD_NAME | grep -A 3 "Events"
```

## Cleanup

To remove the Redis deployment:

```bash
# Delete deployment
kubectl delete deployment redis-deployment

# Delete ConfigMap
kubectl delete configmap my-redis-config
```

Or delete everything at once:
```bash
kubectl delete -f redis-deployment.yaml
```

## Scaling (Future Considerations)

Currently configured with 1 replica for testing. To scale:

```bash
# Scale to multiple replicas
kubectl scale deployment redis-deployment --replicas=3
```

**Note**: For production, consider:
- Redis Sentinel for high availability
- Redis Cluster for horizontal scaling
- Persistent volumes instead of emptyDir
- Resource limits in addition to requests
- Liveness and readiness probes

## Next Steps for Production

1. **Persistent Storage**: Replace emptyDir with PersistentVolumeClaim
2. **High Availability**: Implement Redis Sentinel or Cluster mode
3. **Monitoring**: Add Prometheus metrics and Grafana dashboards
4. **Resource Limits**: Add memory and CPU limits
5. **Health Checks**: Configure liveness and readiness probes
6. **Backup Strategy**: Implement regular data backups
7. **Security**: Add network policies and authentication
8. **Service Exposure**: Create Kubernetes Service for pod discovery

## Support

For issues or questions related to this deployment, contact the Nautilus application development team.

## License

Internal use only - Nautilus Application Development Team

---

**Version**: 1.0.0  
**Last Updated**: November 2025  
**Environment**: Testing/Development
