### 🧾 **readme.md**

# Git Remote Update Task

## 🧩 Task Description
The xFusionCorp development team maintains a project under the `/opt/apps.git` repository, cloned locally at `/usr/src/kodekloudrepos/apps`.  
Due to recent updates in the Git server configuration on the Storage Server, the DevOps team needed to add a new Git remote and push the latest code changes.

---

## 🧠 Task Requirements
1. Add a new remote named **`dev_apps`** in the `/usr/src/kodekloudrepos/apps` repository, pointing to `/opt/xfusioncorp_apps.git`.
2. Copy the file `/tmp/index.html` into the repository.
3. Add and commit this file to the **`master`** branch.
4. Push the **`master`** branch to the new remote `dev_apps`.

---

## ⚙️ Steps Performed
```bash
# Navigate to repository directory
cd /usr/src/kodekloudrepos/apps

# Add new remote named dev_apps
git remote add dev_apps /opt/xfusioncorp_apps.git

# Verify the remote addition
git remote -v

# Copy the file to the repository
cp /tmp/index.html .

# Stage and commit the file
git add index.html
git commit -m "Added index.html file to master branch"

# Push the master branch to new remote
git push dev_apps master

# Verify the push
git ls-remote dev_apps
````

---

## ✅ Verification Output

```
dev_apps        /opt/xfusioncorp_apps.git (fetch)
dev_apps        /opt/xfusioncorp_apps.git (push)

Enumerating objects: 6, done.
Counting objects: 100% (6/6), done.
Writing objects: 100% (6/6), 600 bytes | 600.00 KiB/s, done.
To /opt/xfusioncorp_apps.git
 * [new branch]      master -> master

079465e697f8602d3b3c8d47e0f928c7f508075e        refs/heads/master
```

---

## 🏁 Result

✅ The new remote `dev_apps` was successfully added.
✅ The `index.html` file was committed and pushed to the new remote’s `master` branch.

---

**Author:** *Natasha (on ststor01)*
**Validated by:** *DevOps Team – xFusionCorp Industries*

```
