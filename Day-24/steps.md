# Steps to Create New Branch

1. **Login to Storage Server**
   ```bash
   ssh natasha@ststor01
Navigate to Git repository

bash
Copy code
cd /usr/src/kodekloudrepos/blog
Fix Git safe directory issue (if error occurs)

bash
Copy code
git config --global --add safe.directory /usr/sr c/kodekloudrepos/blog
Check current branch

bash
Copy code
git status
git branch
Create new branch from master

bash
Copy code
git checkout -b xfusioncorp_blog master
Verify branch creation

bash
Copy code
git branch
Expected output:

markdown
Copy code
* xfusioncorp_blog
  master
yaml
Copy code

---

### 📄 `command.sh`
```bash
#!/bin/bash

# Navigate to repository
cd /usr/src/kodekloudrepos/blog || exit 1

# Mark directory as safe (to avoid ownership issues)
git config --global --add safe.directory /usr/src/kodekloudrepos/blog

# Create new branch from master
git checkout -b xfusioncorp_blog master

# Show branches to verify
git branch
Make script executable:

bash
Copy code
chmod +x command.sh
