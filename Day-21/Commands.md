# ----------------------------------------------------------
# Day-21 | DevOps-365-Days
# Create a bare Git repository on the Storage server
# ----------------------------------------------------------
# Run as **natasha** on ststor01

set -euo pipefail

REPO_PATH="/opt/blog.git"

echo "1️⃣  Installing Git ..."
sudo yum install -y git

echo "2️⃣  Creating bare repository at ${REPO_PATH} ..."
sudo git init --bare "$REPO_PATH"

echo "3️⃣  Fixing ownership (natasha:natasha) ..."
sudo chown -R natasha:natasha "$REPO_PATH"

echo "4️⃣  Adding safe-directory exceptions ..."
git config --global --add safe.directory "$REPO_PATH"
sudo git config --system --add safe.directory "$REPO_PATH"

echo "5️⃣  Verifying repository structure ..."
ls -lah "$REPO_PATH"

echo "✅  Done! Clone with:  git clone natasha@ststor01:${REPO_PATH}"
git clone natasha@ststor01:/opt/blog.git
cd blog
echo "# Blog App" > README.md
git add . && git commit -m "init" && git push origin master
