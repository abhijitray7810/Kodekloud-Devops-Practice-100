# Step 1: Check the status of the deployment
kubectl get deployments

# Step 2: Describe the deployment to see error details
kubectl describe deployment redis-deployment

# Step 3: Check pods status and identify the problem
kubectl get pods -l app=redis

# Step 4: Describe one of the pods to see detailed error logs
kubectl describe pod <pod-name>

# Step 5: Check pod logs (use if container starts but fails)
kubectl logs <pod-name>

# Step 6: Common fix - If image name is incorrect, edit the deployment
kubectl edit deployment redis-deployment

# Inside the editor, ensure the image is correct:
# Example correct image:
#   image: redis:latest
# Save and exit (:wq in vi)

# Step 7: Verify that the new pods are being created
kubectl get pods -l app=redis -w

# Step 8: If deployment is still not healthy, delete bad pods (they will be recreated automatically)
kubectl delete pod <pod-name>

# Step 9: Once all pods are running, confirm status
kubectl get all -l app=redis

# Step 10: Optional – check service exposing Redis
kubectl get svc
