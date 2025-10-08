# Step-by-Step Git PR Workflow

## Step 1: SSH into Server
```bash
ssh max@<server-ip>
```
# Password: Max_pass123
```
cd ~/repo_name
ls -la
```
## Step 2: Verify Repository Contents
```bash
ls stories/
git log --oneline --author="Sarah"
git log
```
## Step 3: Confirm Max's Branch
```bash
git branch -r
git checkout story/fox-and-grapes
ls
```
## Step 4: Create Pull Request in Gitea
Log in as Max.

Go to repository → Click Create Pull Request.

PR title: Added fox-and-grapes story

Source branch: story/fox-and-grapes

Destination branch: master

Assign Tom as reviewer.

## Step 5: Review and Merge as Tom
Logout Max → Login Tom

Navigate to PR: Added fox-and-grapes story

Review the content.

Approve the PR.

Merge PR into master.

## Step 6: Verify Merge
```bash
git checkout master
git pull origin master
git log --oneline
```
## Step 7: Documentation
Take screenshots or record the workflow for reference.
---

If you want, I can also **make a visual flow diagram of this PR workflow** that you can include in the `README.md`—it makes it super clear for reviewers.  

Do you want me to do that?
