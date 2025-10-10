# Ecommerce Git Repository - Stash Restore Task

This repository contains the code for the Ecommerce application.  
The purpose of this documentation is to explain how to restore stashed changes in this repository and push them to the remote repository.

## Repository Path
`/usr/src/kodekloudrepos/ecommerce`

## Task
- Restore stashed changes with the identifier `stash@{1}`.
- Commit the changes with a descriptive message.
- Push the changes to the origin remote repository.
```

---



### **3️⃣ `command.md`**
```markdown
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
````

---

If you want, I can also **combine all of these into a single folder structure** ready to push to GitHub for documentation purposes.

Do you want me to do that next?
