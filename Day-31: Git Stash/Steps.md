# Steps to Restore Stashed Changes

## 1. **Navigate to the repository**
```bash
cd /usr/src/kodekloudrepos/ecommerce
````

## 2. **Allow Git to trust the repository**

   ```bash
   sudo git config --global --add safe.directory /usr/src/kodekloudrepos/ecommerce
   ```

## 3. **Check existing stashes**

   ```bash
   git stash list
   ```

## 4. **Apply the desired stash**

   ```bash
   git stash apply stash@{1}
   ```

## 5. **Verify the changes**

   ```bash
   git status
   git diff
   ```

## 6. **Add and commit changes**

   ```bash
   git add .
   git commit -m "Restored changes from stash@{1}"
   ```

## 7.Push the changes to remote**

   ```bash
   git push origin master
   ```

## 8. **(Optional) Delete the applied stash**

   ```bash
   git stash drop stash@{1}
   ```

````

---
