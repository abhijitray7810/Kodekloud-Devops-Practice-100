#!/usr/bin/env bash
# Clone /opt/media.git into /usr/src/kodekloudrepos as user natasha
# No sudo, no permission changes, no alterations to existing content.

set -euo pipefail

REPO_SRC="/opt/media.git"
REPO_DST="/usr/src/kodekloudrepos"

# 1. Make sure we are natasha
if [[ "$(whoami)" != "natasha" ]]; then
  echo "ERROR: run this script as user natasha (no sudo)."
  exit 1
fi

# 2. Ensure destination folder exists (it already does per task)
if [[ ! -d "$REPO_DST" ]]; then
  echo "ERROR: $REPO_DST does not exist."
  exit 1
fi

# 3. Clone
cd "$REPO_DST"
git clone "$REPO_SRC"

# 4. Quick sanity check
echo "Clone complete.  Contents of $REPO_DST:"
ls -ld "$REPO_DST"/*
Step 1: Connect to the Storage Server
```bash
ssh natasha@ststor01
```
Step 2: Navigate to the Target Directory
`bash
cd /usr/src/kodekloudrepos
`
Step 3: Clone the Repository
`bash
git clone /opt/media.git
`
Alternative Method (if the above doesn't work)
If you encounter any issues with the basic clone command, you can also try:
`bash
git clone /opt/media.git /usr/src/kodekloudrepos/media
`
Verification:
After cloning, you can verify the repository was cloned correctly by:
`bash
ls -la /usr/src/kodekloudrepos/
cd /usr/src/kodekloudrepos/media
git status
`
