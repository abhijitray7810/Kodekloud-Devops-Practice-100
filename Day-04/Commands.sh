sudo dnf install epel-release -y
sudo dnf install ansible -y
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yaml
ansible-playbook -i inventory.ini lbr_setup.yml
curl -I http://stlb01
for i in {1..10}; do curl http://stlb01; done
