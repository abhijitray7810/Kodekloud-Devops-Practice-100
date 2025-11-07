#!/bin/bash

# Step 1: Check the deployment status
echo "=== Checking Redis Deployment Status ==="
kubectl get deployment redis-deployment

# Step 2: Check the pods status
echo -e "\n=== Checking Redis Pods Status ==="
kubectl get pods -l app=redis

# Step 3: Describe the deployment to see events and configuration
echo -e "\n=== Describing Redis Deployment ==="
kubectl describe deployment redis-deployment

# Step 4: Check pod details and events
echo -e "\n=== Describing Redis Pods ==="
kubectl describe pods -l app=redis

# Step 5: Check pod logs if any pods exist
echo -e "\n=== Checking Pod Logs ==="
POD_NAME=$(kubectl get pods -l app=redis -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
if [ ! -z "$POD_NAME" ]; then
    kubectl logs $POD_NAME
else
    echo "No pods found to check logs"
fi

# Step 6: Check the deployment YAML configuration
echo -e "\n=== Deployment Configuration ==="
kubectl get deployment redis-deployment -o yaml
