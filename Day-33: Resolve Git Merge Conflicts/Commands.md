# Step 1: SSH into the storage server
```
ssh max@ststor01
```
# Password: Max_pass123

# Step 2: Go to the repository directory
```
cd /home/max/story-blog
```
# Step 3: Check Git status to verify local changes
```
git status
```
# Step 4: Check the current branch
```
git branch
```
# Step 5: Edit the story-index.txt file to ensure all 4 story titles are listed
```
vi story-index.txt
```
# (Add missing titles and correct the typo "Mooose" → "Mouse")

# Step 6: Stage the changes
```
git add story-index.txt
```
# Step 7: Commit the changes
```
git commit -m "Fixed typo in 'The Lion and the Mouse' and updated story titles"
```
# Step 8: Push to origin repository
```
git push origin master
```
# If facing permission or auth errors, configure remote again
```
git remote -v
git remote set-url origin git@<gitea_server>:sarah/story-blog.git
```
# Retry push
```
git push origin master
```
# Step 9: Verify push on Gitea UI (login as Sarah or Max)
# URL: http://<gitea-server>:3000
# Credentials:
#   Username: sarah / max
#   Password: Sarah_pass123 / Max_pass123
