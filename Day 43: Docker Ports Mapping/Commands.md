# Step 1: Pull the nginx:alpine-perl image
docker pull nginx:alpine-perl

# Step 2: Create and run a container named 'cluster' using the pulled image
# Map host port 8083 to container port 80
docker run -d --name cluster -p 8083:80 nginx:alpine-perl

# Step 3: Verify the container is running
docker ps
