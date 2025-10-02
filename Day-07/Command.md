# Go to Ansible directory
```
cd /home/thor/ansible
```
# Create inventory & playbook
```
vi inventory.ini
vi playbook.yaml
```
# Run playbook
```
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yaml
```
# ✅ Verification (on stapp03)
```
curl http://localhost:5004/official/
curl http://localhost:5004/games/
```
