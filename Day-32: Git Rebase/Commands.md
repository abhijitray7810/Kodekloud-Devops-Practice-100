## Login in storage server
```
ssh natasha@ststor01
```
## change Directory 
```
cd /usr/src/kodekloudrpos/apps
```
## Switch to the Feature branch
```
sudo git checkout feature
```
## Rebase the feature branch on top of master
```
sudo git rebase master
```
## Push the rebased feature branch to remote
```
sudo git push origin feature --force
```
