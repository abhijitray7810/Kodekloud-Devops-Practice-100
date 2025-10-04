# Nautilus Repository Commands

```bash
# Navigate to the repository
cd /usr/src/kodekloudrepos/beta

# Ensure master branch is up-to-date
git checkout master
git pull origin master

# Create a new branch 'nautilus' from master
git checkout -b nautilus

# Copy the file into the repo
cp /tmp/index.html .

# Add and commit the file
git add index.html
git commit -m "Add index.html to nautilus branch"

# Merge 'nautilus' branch back into master
git checkout master
git merge nautilus

# Push both branches to the origin
git push origin nautilus
git push origin master




**Command to create it:**

```bash
cat <<EOL > /usr/src/kodekloudrepos/beta/commands.md
# Nautilus Repository Commands

\`\`\`bash
# Navigate to the repository
cd /usr/src/kodekloudrepos/beta

# Ensure master branch is up-to-date
git checkout master
git pull origin master

# Create a new branch 'nautilus' from master
git checkout -b nautilus

# Copy the file into the repo
cp /tmp/index.html .

# Add and commit the file
git add index.html
git commit -m "Add index.html to nautilus branch"

# Merge 'nautilus' branch back into master
git checkout master
git merge nautilus

# Push both branches to the origin
git push origin nautilus
git push origin master
\`\`\`
EOL
