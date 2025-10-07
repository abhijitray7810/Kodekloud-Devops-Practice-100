1. SSH into the storage server:
```bash
ssh user@storage-server
```
2. Navigate to the repository:
```bash
cd /usr/src/kodekloudrepos/blog
```
3. Check the current state:
```bash
git status
git branch -a
```
4. Switch to master branch:
```bash
git checkout master
```
5. Find the specific commit in the feature branch:
```bash
git log feature --oneline --grep="Update info.txt"
```
6. Cherry-pick the commit:
```bash
git cherry-pick <commit-hash>
```
7. Push the changes:
```bash
git push origin master
```
