# Git Commands Reference

# 1. Navigate to the repository
cd /usr/src/kodekloudrepos/ecommerce

# 2. Mark repository as safe
sudo git config --global --add safe.directory /usr/src/kodekloudrepos/ecommerce

# 3. Check stashed changes
git stash list

# 4. Apply specific stash
git stash apply stash@{1}

# 5. Check repository status and changes
git status
git diff

# 6. Stage and commit restored changes
git add .
git commit -m "Restored changes from stash@{1}"

# 7. Push changes to remote
git push origin master

# 8. Remove the stash if no longer needed
git stash drop stash@{1}
