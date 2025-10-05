# Navigate to the repository directory
cd /usr/src/kodekloudrepos/apps

# Add new remote named dev_apps pointing to /opt/xfusioncorp_apps.git
git remote add dev_apps /opt/xfusioncorp_apps.git

# Copy index.html file from /tmp to the repo
cp /tmp/index.html .

# Add the file to git staging
git add index.html

# Commit the changes
git commit -m "Added index.html file to master branch"

# Push master branch to new remote dev_apps
git push dev_apps master


✅ Verification Summary
Step	Command	Result
1	git remote add dev_apps /opt/xfusioncorp_apps.git	Remote added successfully
2	git remote -v	Shows both origin and new dev_apps remotes
3	cp /tmp/index.html .	File copied successfully
4	git add index.html	File staged successfully
5	git commit -m "Added index.html file to master branch"	Commit created (079465e)
6	git push dev_apps master	Master branch pushed successfully to /opt/xfusioncorp_apps.git
7	git ls-remote dev_apps	Shows correct HEAD and refs — push verified ✅
🏁 Final Confirmation

Output of:

079465e697f8602d3b3c8d47e0f928c7f508075e        refs/heads/master


means your master branch was successfully pushed to the new remote dev_apps.

📘 Next Step (Optional)

If you want to document your success for submission or internal record, just create the files:

echo "# Git Remote Update Task" > readme.md
echo "✅ Added new remote 'dev_apps' and pushed master branch successfully." >> r
