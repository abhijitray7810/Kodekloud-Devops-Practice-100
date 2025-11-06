# Grafana Kubernetes Deployment

## Overview
This repository contains Kubernetes manifests for deploying Grafana on a Kubernetes cluster for the Nautilus DevOps team. Grafana will be used to collect and analyze analytics from various applications.

## Prerequisites
- Kubernetes cluster up and running
- `kubectl` configured to communicate with the cluster
- Access to jump_host with kubectl configured

## Architecture

### Components
1. **Deployment**: `grafana-deployment-datacenter`
   - Image: `grafana/grafana:latest`
   - Replicas: 1
   - Container Port: 3000
   
2. **Service**: `grafana-service-datacenter`
   - Type: NodePort
   - NodePort: 32000
   - Target Port: 3000

## Deployment Instructions

### Step 1: Clone or Download Configuration
Ensure you have the `grafana-deployment.yaml` file available.

### Step 2: Deploy to Kubernetes
```bash
kubectl apply -f grafana-deployment.yaml
```

Expected output:
```
deployment.apps/grafana-deployment-datacenter created
service/grafana-service-datacenter created
```

### Step 3: Verify Deployment
```bash
# Check deployment status
kubectl get deployment grafana-deployment-datacenter

# Check pods
kubectl get pods -l app=grafana

# Check service
kubectl get svc grafana-service-datacenter

# Detailed pod information
kubectl describe pod -l app=grafana
```

### Step 4: Wait for Pod to be Ready
```bash
kubectl wait --for=condition=ready pod -l app=grafana --timeout=300s
```

## Accessing Grafana

### Get Node IP
```bash
kubectl get nodes -o wide
```

### Access URL
```
http://<NODE_IP>:32000
```

Replace `<NODE_IP>` with any node IP from your cluster.

### Default Credentials
- **Username**: `admin`
- **Password**: `admin`

**Important**: You will be prompted to change the password on first login.

## Troubleshooting

### Pod Not Starting
```bash
# Check pod logs
kubectl logs -l app=grafana

# Describe pod for events
kubectl describe pod -l app=grafana
```

### Service Not Accessible
```bash
# Verify service endpoints
kubectl get endpoints grafana-service-datacenter

# Check if port is open
kubectl get svc grafana-service-datacenter
```

### Common Issues

1. **ImagePullBackOff**: Check internet connectivity and image name
   ```bash
   kubectl describe pod -l app=grafana | grep -A 5 Events
   ```

2. **CrashLoopBackOff**: Check pod logs for errors
   ```bash
   kubectl logs -l app=grafana --previous
   ```

3. **NodePort not accessible**: Verify firewall rules allow port 32000

## Resource Requirements

### Requests
- Memory: 128Mi
- CPU: 100m

### Limits
- Memory: 512Mi
- CPU: 500m

## Maintenance

### Scaling the Deployment
```bash
kubectl scale deployment grafana-deployment-datacenter --replicas=3
```

### Updating Grafana Version
Edit the deployment and change the image tag:
```bash
kubectl set image deployment/grafana-deployment-datacenter grafana=grafana/grafana:10.2.0
```

### Rolling Back
```bash
kubectl rollout undo deployment/grafana-deployment-datacenter
```

## Cleanup

To remove all resources:
```bash
kubectl delete -f grafana-deployment.yaml
```

Or individually:
```bash
kubectl delete deployment grafana-deployment-datacenter
kubectl delete service grafana-service-datacenter
```

## Configuration Details

### Environment Variables
- `GF_SERVER_HTTP_PORT`: Set to 3000 (Grafana default)

### Ports
- **Container Port**: 3000
- **Service Port**: 3000
- **NodePort**: 32000

## Security Considerations

1. **Change Default Password**: Always change the default admin password immediately after first login
2. **Network Policies**: Consider implementing network policies to restrict access
3. **HTTPS**: For production, configure TLS/SSL certificates
4. **Resource Limits**: Configured to prevent resource exhaustion

## Next Steps

After deployment:
1. Access Grafana at `http://<NODE_IP>:32000`
2. Login with default credentials
3. Change the admin password
4. Configure data sources
5. Create dashboards for your applications

## Support

For issues or questions:
- Check Kubernetes cluster logs
- Review Grafana official documentation: https://grafana.com/docs/
- Contact Nautilus DevOps team

## Version Information
- Grafana Image: `grafana/grafana:latest`
- Kubernetes API Version: `apps/v1` (Deployment), `v1` (Service)

---

**Last Updated**: November 2025  
**Maintained By**: Nautilus DevOps Team
