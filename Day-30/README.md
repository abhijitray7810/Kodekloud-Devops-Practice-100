
### commands.md

```bash
# Navigate to repository
dd /usr/src/kodekloudrepos/news

# Mark repository as safe directory
git config --global --add safe.directory /usr/src/kodekloudrepos/news

# Check commit history
git log --oneline

# Reset to commit with 'add data.txt file'
sudo git reset --hard 1f1d6ef

# Mark remote repository as safe (if needed)
sudo git config --global --add safe.directory /opt/news.git

# Push changes forcefully to remote
sudo git push origin master --force
```

---

### readme.md

# News Repository Cleanup

This repository is a test repository for the Nautilus application development team. It has been cleaned to retain only two commits:

1. `initial commit`
2. `add data.txt file`

All unnecessary commits and changes have been removed from the commit history.

---

### steps.md

# Steps to Reset Git Repository

1. **Navigate to the repository**:

   ```bash
   cd /usr/src/kodekloudrepos/news
   ```

2. **Mark repository as safe**:

   ```bash
   git config --global --add safe.directory /usr/src/kodekloudrepos/news
   ```

3. **Check the commit history**:

   ```bash
   git log --oneline
   ```

4. **Reset the branch to the desired commit** (commit message: `add data.txt file`):

   ```bash
   sudo git reset --hard <commit-id>
   ```

5. **Mark the remote repository as safe** (if needed):

   ```bash
   sudo git config --global --add safe.directory /opt/news.git
   ```

6. **Force push changes to remote**:

   ```bash
   sudo git push origin master --force
   ```

7. **Verify commit history**:

   ```bash
   git log --oneline
   ```

The repository now contains only the initial commit and the `add data.txt file` commit, with all other commits removed.
