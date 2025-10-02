## 🛠 Install Ansible on CentOS/RHEL
# First update system
```
sudo yum update -y
```
# Enable EPEL repository (needed for Ansible)
```
sudo yum install epel-release -y
```
# Install Ansible
```
sudo yum install ansible -y
```
# Verify installation
```
ansible --version
```
## 📂 After installation

Create inventory.ini file with all your app & db servers.

Create playbook.yaml file with tasks (the corrected one I gave you).

# Run the playbook:
```
 ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yaml
```
