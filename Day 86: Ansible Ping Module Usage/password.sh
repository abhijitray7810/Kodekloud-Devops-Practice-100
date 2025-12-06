# Generate SSH key pair (if not already exists)
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""

# Copy SSH public key to App Server 1 (stapp01)
sshpass -p 'Ir0nM@n' ssh-copy-id -o StrictHostKeyChecking=no tony@172.16.238.10

# Copy SSH public key to App Server 2 (stapp02) 
sshpass -p 'Am3ric@' ssh-copy-id -o StrictHostKeyChecking=no steve@172.16.238.11

# Copy SSH public key to App Server 3 (stapp03)
sshpass -p 'BigGr33n' ssh-copy-id -o StrictHostKeyChecking=no banner@172.16.238.12
