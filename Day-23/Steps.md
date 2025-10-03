
---

### ⚙️ `process.sh`

```bash
#!/bin/bash

# Script to automate local setup after Jon forks sarah/story-blog
# Author: DevOps Team

# Variables
GITEA_SERVER="http://<gitea-server>"   # Replace with actual Gitea server URL
USERNAME="jon"
REPO_NAME="story-blog"
FORK_REPO="$USERNAME/$REPO_NAME"
UPSTREAM_REPO="sarah/$REPO_NAME"

echo "=== Setting up local environment for $FORK_REPO ==="

# Clone Jon's fork
git clone $GITEA_SERVER/$FORK_REPO.git
cd $REPO_NAME || exit 1

# Verify origin
echo "Remote repositories configured:"
git remote -v

# Add upstream repository
git remote add upstream $GITEA_SERVER/$UPSTREAM_REPO.git

echo "Upstream repository added:"
git remote -v

echo "=== Setup complete! You can now work on $FORK_REPO ==="
