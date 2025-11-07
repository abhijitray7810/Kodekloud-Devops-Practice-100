#!/bin/bash

# Check for README file in current directory
echo "=== Checking for README files ==="
if [ -f "readme.md" ]; then
    echo "Found readme.md:"
    cat readme.md
elif [ -f "README.md" ]; then
    echo "Found README.md:"
    cat README.md
elif [ -f "README" ]; then
    echo "Found README:"
    cat README
else
    echo "No README file found in current directory"
fi

# Check for any deployment YAML files
echo -e "\n=== Checking for deployment YAML files ==="
ls -la *.yaml *.yml 2>/dev/null || echo "No YAML files found"

# List all files in current directory
echo -e "\n=== Files in current directory ==="
ls -la

# Check the actual deployment from Kubernetes
echo -e "\n=== Current Redis Deployment Configuration ==="
kubectl get deployment redis-deployment -o yaml 2>/dev/null || echo "Deployment not found or kubectl not configured"
