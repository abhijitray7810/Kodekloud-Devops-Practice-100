# Solution for Git Post-Update Hook Task
## Step 1: Connect to the Storage Server
```
sshpass -p 'Bl@kW' ssh -q -o 'StrictHostKeyChecking no'
ssh natasha@ststor01
```
## Step 2: Navigate to the Repository and Check Current Status
```
cd /usr/src/kodekloudrepos/ecommerce
git status
git branch -a
```
## Step 3: Create the Post-Update Hook in the Bare Repository
```
cd /opt/ecommerce.git/hooks/
cat > post-update << 'EOF'
#!/bin/bash
# Post-update hook to create release tags when master branch is updated

# Get the current date in YYYY-MM-DD format
CURRENT_DATE=$(date '+%Y-%m-%d')

# Check if the push was to master branch
if [ "$1" = "refs/heads/master" ]; then
    echo "Creating release tag for master branch update"
    git tag release-${CURRENT_DATE} master
    echo "Release tag release-${CURRENT_DATE} created successfully"
fi
EOF
```
```
chmod +x post-update
```
## Step 4: Merge Feature Branch into Master
```
cd /usr/src/kodekloudrepos/ecommerce
git checkout master
git merge feature
```
## Step 5: Push Changes to Trigger the Hook
```
git push origin master
```
## Step 6: Verify the Hook Worked and Tag Was Created
```
cd /opt/ecommerce.git
git tag
# Should show: release-2025-10-13
```
## Step 7: Test the Hook Again (Optional but Recommended)
```
cd /usr/src/kodekloudrepos/ecommerce
echo "# Test commit" >> README.md
git add README.md
git commit -m "Test commit to verify hook"
git push origin master
```
## Key Points to Remember:
- Current Date: Today is October 13, 2025, so the release tag will be release-2025-10-13
- Hook Location: The post-update hook must be placed in /opt/ecommerce.git/hooks/post-update (the bare repository)
- Permissions: Make sure the hook is executable (chmod +x post-update)
- User: Perform all operations as the natasha user
- Testing: The hook will only trigger when changes are pushed to the master branch
