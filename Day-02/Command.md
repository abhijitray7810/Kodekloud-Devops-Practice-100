sudo dnf install epel-release -y
sudo dnf install ansible -y
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yaml
