# Kubernetes Init Container Deployment - Nautilus Project

## Overview

This project demonstrates the use of Kubernetes Init Containers to perform pre-requisite tasks before the main application container starts. The init container prepares the environment by creating a configuration file that the main container then consumes.

## Architecture

The deployment consists of:
- **Init Container**: Writes a welcome message to a shared volume
- **Main Container**: Continuously reads and displays the message
- **Shared Volume**: EmptyDir volume for data exchange between containers

## Prerequisites

- Kubernetes cluster up and running
- `kubectl` configured to communicate with your cluster
- Appropriate permissions to create deployments

## Deployment Specifications

### Deployment Details
- **Name**: `ic-deploy-nautilus`
- **Replicas**: 1
- **Labels**: `app=ic-nautilus`

### Init Container
- **Name**: `ic-msg-nautilus`
- **Image**: `ubuntu:latest`
- **Purpose**: Write initialization message to shared volume
- **Command**: Creates a file with welcome message
- **Volume Mount**: `/ic` (ic-volume-nautilus)

### Main Container
- **Name**: `ic-main-nautilus`
- **Image**: `ubuntu:latest`
- **Purpose**: Read and display the message continuously
- **Command**: Reads the file every 5 seconds
- **Volume Mount**: `/ic` (ic-volume-nautilus)

### Volume
- **Name**: `ic-volume-nautilus`
- **Type**: emptyDir
- **Purpose**: Temporary storage shared between init and main containers

## Deployment Instructions

### Step 1: Apply the Deployment

```bash
kubectl apply -f ic-deploy-nautilus.yaml
```

### Step 2: Verify Deployment Status

```bash
# Check deployment
kubectl get deployment ic-deploy-nautilus

# Check pods
kubectl get pods -l app=ic-nautilus

# Describe the pod for detailed information
kubectl describe pod -l app=ic-nautilus
```

### Step 3: View Logs

```bash
# View main container logs
kubectl logs -l app=ic-nautilus -f

# View init container logs
kubectl logs -l app=ic-nautilus -c ic-msg-nautilus
```

Expected output (main container):
```
Init Done - Welcome to xFusionCorp Industries
Init Done - Welcome to xFusionCorp Industries
Init Done - Welcome to xFusionCorp Industries
...
```

## How It Works

1. **Pod Creation**: When the pod is created, Kubernetes starts the init container first
2. **Init Container Execution**: The init container runs and writes the message to `/ic/media`
3. **Init Container Completion**: Once the init container completes successfully, it terminates
4. **Main Container Start**: Kubernetes then starts the main container
5. **Message Display**: The main container reads the file created by the init container and displays it every 5 seconds

## Verification Steps

### Check Pod Events
```bash
kubectl get events --sort-by=.metadata.creationTimestamp | grep ic-deploy-nautilus
```

### Check Init Container Status
```bash
kubectl get pod -l app=ic-nautilus -o jsonpath='{.items[0].status.initContainerStatuses[*].state}'
```

### Check Main Container Status
```bash
kubectl get pod -l app=ic-nautilus -o jsonpath='{.items[0].status.containerStatuses[*].state}'
```

## Troubleshooting

### Pod in Init Status
If the pod is stuck in `Init:0/1` status:
```bash
kubectl logs -l app=ic-nautilus -c ic-msg-nautilus
kubectl describe pod -l app=ic-nautilus
```

### Main Container CrashLoopBackOff
If the main container is crashing:
```bash
kubectl logs -l app=ic-nautilus --previous
```

### No Output in Logs
Verify the file was created:
```bash
kubectl exec -it <pod-name> -- cat /ic/media
```

## Cleanup

To remove the deployment:

```bash
kubectl delete deployment ic-deploy-nautilus
```

Verify deletion:
```bash
kubectl get deployment ic-deploy-nautilus
kubectl get pods -l app=ic-nautilus
```

## Use Cases

This pattern is useful for:
- **Configuration Generation**: Creating config files before app starts
- **Database Migration**: Running schema updates before application deployment
- **Dependency Verification**: Checking if required services are available
- **Data Seeding**: Populating initial data
- **Security Setup**: Fetching secrets or certificates

## Real-World Applications

In production environments, init containers can be used to:
- Wait for database to be ready
- Clone a git repository
- Fetch application configuration from external sources
- Register the service with a service registry
- Perform pre-flight checks

## Additional Resources

- [Kubernetes Init Containers Documentation](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
- [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
- [EmptyDir Volumes](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir)

## Notes

- The emptyDir volume is ephemeral and will be deleted when the pod is removed
- Init containers run sequentially and must complete successfully before the main container starts
- If an init container fails, Kubernetes restarts the pod until the init container succeeds

## Author

xFusionCorp Industries DevOps Team

## License

Internal Use Only
